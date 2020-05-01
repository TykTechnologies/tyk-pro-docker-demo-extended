#!/bin/bash

dashboard_sso_base_url="http://localhost:3001"
identity_broker_base_url="http://localhost:3010"

# Create Identity Broker Profiles
organisation_id=$(cat .organisation-id)
dashboard_user_api_credentials=$(cat .dashboard-user-api-credentials)
user_group_default_id=$(cat .user_group_default_id)
user_group_readonly_id=$(cat .user_group_readonly_id)
user_group_admin_id=$(cat .user_group_admin_id)
identity_broker_api_credentials=$(cat ./volumes/tyk-identity-broker/tib.conf | jq -r .Secret)
identity_broker_profile_tyk_dashboard_data=$(cat ./bootstrap-data/tyk-identity-broker/profile-tyk-dashboard.json | \
  sed 's/ORGANISATION_ID/'"$organisation_id"'/' | \
  sed 's/DASHBOARD_USER_API_CREDENTIALS/'"$dashboard_user_api_credentials"'/' | \
  sed 's/DASHBOARD_USER_GROUP_DEFAULT/'"$user_group_default_id"'/' | \
  sed 's/DASHBOARD_USER_GROUP_READONLY/'"$user_group_readonly_id"'/' | \
  sed 's/DASHBOARD_USER_GROUP_ADMIN/'"$user_group_admin_id"'/')
curl $identity_broker_base_url/api/profiles/tyk-dashboard -s \
  -H "Authorization: $identity_broker_api_credentials" \
  -d "$(echo $identity_broker_profile_tyk_dashboard_data)" > /dev/null

cat <<EOF   
   Dashboard (SSO)
               URL : $dashboard_sso_base_url
          Username : dashboard.admin@example.org
          Password : Abcd1234
  
   Identity Broker
       Profile URL : $identity_broker_base_url/auth/tyk-dashboard/openid-connect
               
EOF
                     
