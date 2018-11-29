def tenantName
def ISSolName
def UMSolName
def response
def responseStatus

def deployLatestBuildAssetAndConfigToCloudGIT(tenantName){
    dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT'){
        for (int i = 1; i <= 3; i++) {
            bat "echo print stage :: $i-$i"  
            if(i <= 2){
                ISSolName = "stage00-Sol${i}-Sol${i}IS"
                if( i != 1){
                    UMSolName = "stage00-Sol${i}-Sol${i}UM"
                }
            }
            else{
                ISSolName = "stage00-Sol${i}-Sol${i}IS1"
                UMSolName = "stage00-Sol${i}-Sol${i}UM"
            }                           
            if(i != 1){
                echo 'pushing the UM configuration'
                bat "echo ${UMSolName}"
                bat "mkdir ${tenantName}-${UMSolName}"
                dir("C:/CloudTransformation/SAGLiveWorkspace/CloudGIT/${tenantName}-${UMSolName}"){
                    bat 'git config --global http.sslVerify false'
                    bat 'git config --global credential.helper cache'
                    bat 'git config --global push.default simple' 
                    checkout([ $class: 'GitSCM', branches: [[name: '*/master']], extensions: [ [$class: 'CloneOption', noTags: true, reference: '', shallow: true] ], 
                    submoduleCfg: [], userRemoteConfigs: [[ credentialsId: 'cloudUsernamePassword', 
                    url: "https://${tenantName}.saglive.com/integration/rest/internal/wmic-git/${UMSolName}"]]])
                    if (!fileExists('CC')) {
                        bat 'mkdir CC'
                    }
                    echo 'copy the UM build configuration'
                    dir("C:/CloudTransformation/SAGLiveWorkspace/CloudGIT/${tenantName}-${UMSolName}/CC"){
                        bat 'cp C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild/CC/localhost-Universal-Messaging-umserver* .'	
                    }                                       
                    bat 'git status'
                    bat 'git remote show origin'
                    bat 'git show-ref'
                    bat 'git add .'
                    bat 'git commit -am "pushing the latest UM build"' 
                    echo "pushing assets/config to ${UMSolName}" 
                    bat 'git push origin HEAD:master'  
                }
            }
            bat "echo ${ISSolName}"                            
            bat "mkdir ${tenantName}-${ISSolName}"
            dir("C:/CloudTransformation/SAGLiveWorkspace/CloudGIT/${tenantName}-${ISSolName}"){
                echo 'pushing the IS Assets/configuration'
                bat 'git config --global http.sslVerify false'
                bat 'git config --global credential.helper cache'
                bat 'git config --global push.default simple' 
                checkout([ $class: 'GitSCM', branches: [[name: '*/master']], extensions: [ [$class: 'CloneOption', noTags: true, reference: '', shallow: true] ], 
                submoduleCfg: [], userRemoteConfigs: [[ credentialsId: 'cloudUsernamePassword', 
                url: "https://${tenantName}.saglive.com/integration/rest/internal/wmic-git/${ISSolName}"]]])
                if (!fileExists('IS')) {
                    bat 'mkdir IS'
                }
                echo 'copy the IS build assets'
                dir("C:/CloudTransformation/SAGLiveWorkspace/CloudGIT/${tenantName}-${ISSolName}/IS"){
                    bat 'cp -r C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild/IS/. .'
                }
                if (!fileExists('CC')) {
                    bat 'mkdir CC'
                }
                echo 'copy the IS build configuration'
                dir("C:/CloudTransformation/SAGLiveWorkspace/CloudGIT/${tenantName}-${ISSolName}/CC"){
                    bat 'cp C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild/CC/localhost-OSGI-IS_default* .'	
                }                                       
                bat 'git status'
                bat 'git remote show origin'
                bat 'git show-ref'
                bat 'git add .'
                bat 'git commit -am "pushing the latest IS build"' 
                echo "pushing assets/config to ${ISSolName}" 
                bat 'git push origin HEAD:master'  
            }
        }
    }
}


pipeline{
    agent{
        node{
            label 'DesignerWin'
            customWorkspace 'C:/CloudTransformation/SAGLiveWorkspace'
            }
        }
    environment {
        userHome="C: + %homepath%"
    }
    stages{
            stage('checkout GITAssets'){
                steps{
                    script{

                        echo 'checkout GITAssets'
                        if (!fileExists('Assets')) {
                            bat 'mkdir Assets'
                            dir('C:/CloudTransformation/SAGLiveWorkspace/Assets'){ 
                                echo 'cloning the project'                              
                                bat 'git clone --recurse-submodules https://github.com/AbhishekGupta1506/CloudSAGLiveAssets.git'
                        }
                        } else {
                            echo 'Assets directory exist'
                            dir('C:/CloudTransformation/SAGLiveWorkspace/Assets/CloudSAGLiveAssets'){                            
                                echo 'pulling the updates'                              
                                bat 'git pull'
                                bat 'git submodule update'
                            }
                        }                    
                    }                                                        
                }
            }
        stage('Install ABE'){
            steps{
                script{
                    dir('C:/CloudTransformation/SAGLiveWorkspace/script'){
                        bat 'sagabeinstall.bat'
                    }
                    
                }
            }
        }
        stage('Build'){
            steps{
                script{
                    bat 'cp C:/CloudTransformation/SAGLiveWorkspace/script/build.properties C:/SoftwareAG103ABE/common/AssetBuildEnvironment/master_build'
                    dir('C:/SoftwareAG103ABE/common/AssetBuildEnvironment/bin'){
                        bat 'build.bat'
                    }

                    if (fileExists('CloudGIT')) {
                        bat 'rd /s /q CloudGIT'
                    }
                    bat 'mkdir CloudGIT'

                }
            }
        }  
        stage('Deploy'){                    
            parallel{
                stage('Tenant1'){
                    steps{
                    echo 'deploy assets cloud LAR'
                    script{                        
                        //dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT'){
                        deployLatestBuildAssetAndConfigToCloudGIT "siqa1"
                        //}
                        }               
                    }
                }

               /** stage('Tenant2'){
                    steps{
                    echo 'deploy assets cloud LAR'
                    script{                        
                        //dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT'){
                            deployLatestBuildAssetAndConfigToCloudGIT "siqa2"
                        //}
                        }               
                    }
                }**/
                stage('Tenant3'){                   
                    steps{
                    echo 'deploy assets cloud LAR'
                    script{                        
                        //dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT'){
                            deployLatestBuildAssetAndConfigToCloudGIT "siqa3"
                        //}
                        }               
                    }                
                 }
                /** stage('Tenant4'){                   
                    steps{
                    echo 'deploy assets cloud LAR'
                    script{                        
                        //dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT'){
                            deployLatestBuildAssetAndConfigToCloudGIT "siqa3"
                        //}
                        }               
                    }                
                 }
                 stage('Tenant5'){                   
                    steps{
                    echo 'deploy assets cloud LAR'
                    script{                        
                        //dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT'){
                            deployLatestBuildAssetAndConfigToCloudGIT "siqa3"
                        //}
                        }               
                    }                
                 }**/
            }            
        }   
        stage('Test'){
            steps{
                script{
                    
                    for(int i=0;i<10;i++){
                        //echo "Inside for"
                        try{
                            echo "Inside try"
                            response = httpRequest authentication: 'cloudUsernamePassword', url: "https://siqa1.saglive.com/integration/clouddeployment/service/development/Sol2/Sol2IS/invoke/umassets.jmsMessaging.UMQueue.mixedQueue.services.publisher:publishservice"
                            echo "Status: ${env.response.status}"                        
                            responseStatus = "${env.response.status}"
                            echo "status: ${responseStatus}"
                            if(responseStatus == "200"){
                                echo "Inside if"
                                echo "Status: passed with status ${responseStatus}"
                                break
                            } 
                            
                        }
                        catch (Exception e){
                            //echo "Inside catch: ${e}"
                            //responseStatus = "${response.status}"
                            echo "Inside catch: HTTP request failed"
                            echo "Status: ${env.response.status}"                        
                            responseStatus = "${env.response.status}"
                            echo "status: ${responseStatus}"
                            if(responseStatus == "502"){
                                echo "Inside else if"
                                echo "Status: failed with status ${responseStatus}. Server not available, its restarting"
                                echo "will retry after 10 sec"
                                sleep 10
                            }
                            else{
                                echo "Inside else"
                                echo "Status: failed with status ${responseStatus}. Server not working"
                                break
                            }
                        }
                       
                    }                    
                }                                                        
            }
        }  
    }
}