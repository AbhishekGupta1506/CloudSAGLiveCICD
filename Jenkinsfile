pipeline{
    agent{
        node{
            label 'DesignerWin'
            customWorkspace 'C:/CloudTransformation/SAGLiveWorkspace'
            }
        }
    stages{
        stage('CheckOut'){
            parallel{
                    stage('CheckOut Assets'){
                        steps{
                            script{
                                if (!fileExists('Assets')) {
                                bat 'mkdir Assets'
                                echo 'Assets directory created under ${customWorkspace}'
                            } else {
                                echo 'Assets directory exist'
                            }
                            dir('C:/CloudTransformation/SAGLiveWorkspace/Assets'){
                                
                                //bat 'git clone --recursive https://github.com/AbhishekGupta1506/CloudSAGLiveAssets.git'
                            }
                            }
                            
                            
                            }
                    }
                    stage('CheckOut Config'){
                        steps{
                            script{
                                if (!fileExists('Config')) {
                                bat 'mkdir Config'
                                echo 'Config directory created under ${customWorkspace}'
                            } else {
                                echo 'Config directory exist'
                            }
                            dir('C:/CloudTransformation/SAGLiveWorkspace/Config'){
                            // bat 'git clone --recursive https://github.com/AbhishekGupta1506/CloudSAGLiveConfig.git'
                            }
                            }
                            
                        }
                    }
                }
        }        
    }
}