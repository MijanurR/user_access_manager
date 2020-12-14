module AccessPolicy 
    require 'jsonpath'
    def authorize_access(user_role) 
        user_role = 'default' if user_role.nil? 
        request_url = request.path
        http_method = request.method_symbol.downcase.to_s   
        eligible_rules = get_rules(user_role,request_url)
        eligible_inherited_rules = get_inherited_rules(user_role,request_url) #array of arrays
        matched_rule = get_matched_rule(eligible_rules,http_method) 
        if matched_rule.length.zero?
            eligible_inherited_rules.each do |rules_arr|
                matched_rule = get_matched_rule(rules_arr,http_method)
                break if !matched_rule.length.zero?
            end
        end
         
        #decison maker
        action_type = ''
        action_type = policy_data()[user_role]['default-action']  if matched_rule.length.zero?
        action_type = matched_rule.first['action']  if !matched_rule.length.zero? 
        
        if( action_type =='deny')
            res_json = generate_message_response_json('Access to the requested resource is not allowed')
            render json: res_json, status: 403
        end
    end 
    def generate_message_response_json(message)
        response_data = {}
        response_data['message'] = message
        response_data
    end
    def get_rules(parent_key,request_url)
        policy_master = policy_data()
        return [] if !(policy_master.key?(parent_key) )
        eligible_rules = []
        policy_master[parent_key]["rules"].each do |rule|
            pattern ='absolute' #default
            pattern = rule['url']['pattern'] if  rule['url'].key?('pattern')
            eligible_rules << rule   if pattern == 'absolute' && request_url == rule['url']['value']
            eligible_rules << rule   if pattern == 'regex' && matched_url?(request_url,rule['url']['value'])
        end
        return eligible_rules
    end
    
    def policy_data()
        return Rails.configuration.AccessPolicyMaster
    end
    
    def get_inherited_rules(parent_key,request_url)
        inherited_roles_arr =[]
        inherited_rules_arr =[]
        policy_master = policy_data()
        inherited_role = policy_master[parent_key]["inherits"]
        if !(inherited_role.nil?) 
            while(!inherited_role.nil?) do 
                inherited_roles_arr << inherited_role 
                inherited_rules_arr << get_rules(inherited_role,request_url)
                inherited_role = policy_master[inherited_role]["inherits"] 
            end 
        end
        return inherited_rules_arr
    end
    
    def matched_url?(url,regex_str)
        !!(url =~ Regexp.new(regex_str ))
    end
    
    def get_matched_rule(eligible_rules,http_method)
        matched_rules =[]
        prioriy_arr =[]
        eligible_rules.each do |rule|
            match_found= true
            methods_present = rule.key?('methods')
            params_present = rule.key?('params')
            if(methods_present)
                match_found = false if !(rule['methods'].map(&:downcase).include?(http_method.downcase))
            end
            if(params_present)
                eligible_http_params = rule['params'].select{|x| x['method'].downcase == http_method.downcase} #array
                
                if !eligible_http_params.length.zero?
                    eligible_http_param = eligible_http_params.first
                    param_location ='url' #default
                    param_location = eligible_http_param['param-location'] if eligible_http_param.key?('param-location')
                    param_path = eligible_http_param['param-path'] #string
                    permitted_values = [] #array
                    permitted_values =  eligible_http_param['values'] if eligible_http_param.key?('values')
                    incoming_params_val=nil
                    if(param_location =='url' ||param_location =='body' )
                        incoming_params_val = params[param_path.to_sym]
                    elsif
                        raw_post = JSON.parse(request.raw_post)
                        incoming_params_val = JsonPath.on(raw_post, param_path).first
                    end
                    match_found = false if !(permitted_values.include?(incoming_params_val))  
                end  
            end
            
            if match_found
                matched_rules<< rule  
                prioriy_arr<< rule['priority']
            end
        end #eligible rules end
        if !(matched_rules.length.zero?)
            max_priority = prioriy_arr.map(&:to_i).max
            # select only highest priority rule
            matched_rules = matched_rules.select{|x| x['priority'] == max_priority}
        
        end
        return matched_rules
    end
    
    
end

