def assetsBuildPresent = false
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
        stage('CheckOut Assets'){
            parallel{
                stage('checkout Assets'){
                    steps{
                        script{
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
                stage('checkout AssetsBuild'){
                    steps{
                        script{
                                if (!fileExists('AssetsBuild')) {  
                                    bat 'mkdir AssetsBuild'
                                    dir('C:/CloudTransformation/SAGLiveWorkspace/AssetsBuild'){ 
                                        echo 'cloning the project'                              
                                        bat 'git clone https://github.com/AbhishekGupta1506/CloudSAGLiveAssetBuildUsingABE.git'
                                }
                                } else {
                                    echo 'AssetsBuild directory exist'
                                    dir('C:/CloudTransformation/SAGLiveWorkspace/AssetsBuild/CloudSAGLiveAssetBuildUsingABE'){                            
                                        echo 'pulling the updates'                              
                                        bat 'git pull'
                                    }
                            }                   
                        }                                                        
                    }
                 }
            }
        }
        stage('Build'){
            steps{
                script{
                     


                    dir('C:/SoftwareAG103/common/AssetBuildEnvironment/bin'){
                        bat 'build.bat'
                    }
                }
            }

        }  
        stage('Deploy'){
            //update this step to deploy to Clour LAR/GIT once it is stable
            steps{
                sshagent(credentials : ['AccessGitFromvmsiqacloud02']){
                    dir('C:/CloudTransformation/SAGLiveWorkspace/AssetsBuild/CloudSAGLiveAssetBuildUsingABE'){
                       /** bat 'git config --global user.name AbhishekGupta1506'
                        bat 'git config --global user.email abhishekgupta@gmail.com'
                        //bat 'git commit --amend --reset-author -am "updated the username and email"'
                        bat 'git init'
                        bat 'git remote add origin https://github.com/AbhishekGupta1506/CloudSAGLiveAssetBuildUsingABE.git'
                        bat 'git pull origin master --allow-unrelated-histories'**/
                        bat 'git status'
                        bat 'git add .'
                        bat 'git commit -am "pushing assets build automatically"'
                        bat 'git push git+ssh://git@github.com/AbhishekGupta1506/CloudSAGLiveAssetBuildUsingABE.git --all | true'

                    }
                }
            }
        }     
    }
}