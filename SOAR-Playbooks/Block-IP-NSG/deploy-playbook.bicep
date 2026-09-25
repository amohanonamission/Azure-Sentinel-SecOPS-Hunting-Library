@description('Name of the Logic App Playbook')
param logicAppName string = 'Sentinel-Block-IP-Playbook'

@description('Location for all resources.')
param location string = resourceGroup().location

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  identity: {
    type: 'SystemAssigned' // SC-500 Concept: Zero-Trust identity for automation
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {}
      triggers: {
        MicrosoftSentinelIncident: {
          type: 'ApiConnectionWebhook'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuresentinel\'][\'connectionId\']'
              }
            }
            path: '/IncidentRedirect'
          }
        }
      }
      actions: {
        // Placeholder for the Network Security Group Deny Rule action
        Add_IP_To_NSG_Deny_List: {
          type: 'Http'
          inputs: {
            method: 'PUT'
            uri: 'https://management.azure.com/subscriptions/.../networkSecurityGroups/...'
            authentication: {
              type: 'ManagedServiceIdentity'
            }
          }
        }
      }
    }
  }
}
