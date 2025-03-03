clear all
 load usps.mat;
 result='';
data=trn.X(:,1:7291);
   
trainlabels =trn.y;
trainimages = trn.X(:,1:7291);
 
Ntrain = length(trainlabels);
trainimages = reshape(trainimages,[],Ntrain);
testlabels = tst.y
testimages =tst.X(:,1:2007); 
Ntest = length(testlabels); 
 
for kk=1:7291
    pl=ones(256,1); 
    x=trn.X(:,kk);
    
  
    pl=im2bw(x,0.5);                    %把样本图像转化为二值图
                            %形成神经网络输入向量
        p(:,kk)=pl;         %x
    
end
 
 
t=trainlabels';
%创建BP网络
pr(1:256,1)=0;
pr(1:256,2)=1;
t1=clock;                   %计时开始
%设置训练参数
net=newff(pr,[25 1],{'logsig','purelin'},'traingdx','learngdm');
net.trainParam.epochs=5000;             %设置训练次数
net.trainParam.goal=0.05;               %设置性能函数
net.trainParam.show=10;                 %每10显示
net.trainParam.Ir=0.05;                 %设置学习速率
net=train(net,p,t);                     %训练BP网络
datat=etime(clock,t1)                   %计算设计网络的时间为66.417s
%生成测试样本
 
 
pt(1:256,1)=1;                       
                       %初始化28*28二值图像像素
 
testlabels = tst.y
testimages =tst.X(:,1:2007); 
 
for kk=1:2007
    pl=ones(256,1);                     %初始化28*28二值图像为全白
    
    x=tst.X(:,kk);
    
   pl=im2bw(x,0.5);                    %把样本图像转化为二值图
    pt(:,kk)=pl;                          %
end
[a,Pf,Af]=sim(net,pt);                  %网络仿真
a=round(a)                              %输出识别结果
%测试样本对应的数字（从b401.bmp到b600.bmp 共200个）：
tl=testlabels';
idx2=zeros(1,7191);
k=0;
for i=1:2007

    if a(i)==tl(i)
        k=k+1;
     elseif k>9;
        k=k-1;
    end
    idx2(1,i)=k;
    result=strcat(result,num2str(k));
end
rate=1.00*k/2007;                        %计算最后正确率为0.495
 
 
 
 
coutclassfydada=zeros(10,10);
ypred =testlabels;
sampledatalength=Ntest ;
rearrangeclassfydadalabel=zeros(10,10);
    
    Tep=zeros(1,10);
    for label=1:10
      for j=1:10
      coutclassfydada(label,j)=sum((ypred (find(idx2==label ))==j));
      end
    end
    sum=0;
     for row=1:10
         Tem=coutclassfydada(row,:);
         [Max,indeX]=max(Tem );
         sum=sum+Max;
         rearrangeclassfydadalabel(indeX,:)=coutclassfydada( row,:);
     end
         
     errorRate = 1-sum/sampledatalength ; 
fprintf('Error Rate: %.2f%%\n',100*errorRate);
