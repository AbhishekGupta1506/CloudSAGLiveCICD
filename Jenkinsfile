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
                            dir('C:/CloudTransformation/Assets'){
                                sh 'git clone --recursive https://github.com/AbhishekGupta1506/CloudSAGLiveAssets.git'
                            }
                            
                            }
                    }
                    stage('CheckOut Config'){
                        steps{
                            dir('C:/CloudTransformation/Config'){
                             sh 'git clone --recursive https://github.com/AbhishekGupta1506/CloudSAGLiveConfig.git'
                            }
                        }
                    }
                }
        }        
    }
}