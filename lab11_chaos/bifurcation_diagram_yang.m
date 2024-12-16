clc
clear all
close all
tic
xvals=[];
for beta = linspace(0,4,6001)
    beta;
    xold = 0.1;
    %transient
    for i = 1:500
        xnew = (beta*(xold-xold^2));
        xold = xnew;
    end
    %xnew = xold;
    xss = xnew;
    for i = 1:5000;
        xnew = ((xold-xold^2)*beta);
        xold = xnew;
        xvals(1,length(xvals)+1) = beta; % saving beta values
        xvals(2,length(xvals)) = xnew; % saving xnew values
        if (abs(xnew-xss) < .001)
            break
        end
    end
end 
toc
tic
figure('Color','w','Position',[734 226 992 480]);
plot (xvals(1,:),xvals(2,:),'b.', 'Linewidth', 0.1, 'Markersize', 0.2);
rectangle('Position',[2.7 0 1.3 1],'EdgeColor','r','LineWidth',1.5);
axis tight;
xlabel('Growth Rate r','FontSize',10,'FontWeight','bold');
ylabel('The Attractor','FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
%grid on
xlim([0 4])
toc
tic
figure('Color','w','Position',[734 226 992 480]);
plot (xvals(1,:),xvals(2,:),'b.', 'Linewidth', 0.1, 'Markersize', 0.2);
axis tight;
xlim([2.7 4])
rectangle('Position',[3.4 0.72 0.26 0.22],'EdgeColor','r','LineWidth',1.5);
xlabel('Growth Rate r','FontSize',10,'FontWeight','bold');
ylabel('The Attractor','FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
%grid on
toc
tic
figure('Color','w','Position',[734 226 992 480]);
plot (xvals(1,:),xvals(2,:),'b.', 'Linewidth', 0.1, 'Markersize', 0.2);
axis tight;
xlim([3.4 3.66]);
ylim([0.72 0.94]);
%rectangle('Position',[3.4 0.72 0.26 0.22],'EdgeColor','r','LineWidth',1.5);
xlabel('Growth Rate r','FontSize',10,'FontWeight','bold');
ylabel('The Attractor','FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
%grid on
toc
data1=zeros(100,1);data2=zeros(100,1);data3=zeros(100,1);
for r = 3.8
    xn = 0.1;
    for n = 1:100
        xn1 = (r*(xn-xn^2));
        data1(n) = xn;xn=xn1;        
    end    
    
    xn = 0.2;
    for n = 1:100
        xn1 = (r*(xn-xn^2));
        data2(n) = xn;xn=xn1;        
    end    
    
    xn = 0.3;
    for n = 1:100
        xn1 = (r*(xn-xn^2));
        data3(n) = xn;xn=xn1;        
    end
end
figure('Color','w','Position',[1410 374 491 338]);
plot (1:100,data1,'bs-','LineWidth',1.5);hold on;
plot (1:100,data3,'rs-','LineWidth',1.5);hold off;
legend('x(0)=0.2','x(0)=0.3','Location','southeast')
axis tight;
ylim([0 1])
xlabel('iteration n','FontSize',10,'FontWeight','bold');
ylabel('x(n)','FontSize',10,'FontWeight','bold');
title('r=3.8','FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
data1=zeros(30,1);data2=zeros(30,1);data3=zeros(30,1);
for r = 3.14
    xn = 0.1;
    for n = 1:30
        xn1 = (r*(xn-xn^2));        
        data1(n) = xn;
        xn=xn1;
    end
    
    
    xn = 0.2;
    for n = 1:30
        xn1 = (r*(xn-xn^2));        
        data2(n) = xn;
        xn=xn1;
    end
    
    
    xn = 0.3;
    for n = 1:30
        xn1 = (r*(xn-xn^2));        
        data3(n) = xn;
        xn=xn1;
    end
end
figure('Color','w','Position',[1410 374 491 338]);
plot (1:30,data1,'bs-','LineWidth',1.5);hold on;
plot (1:30,data2,'rs-','LineWidth',1.5);
plot (1:30,data3,'ks-','LineWidth',1.5);hold off;
legend('x(0)=0.1','x(0)=0.2','x(0)=0.3','Location','southeast')
axis tight;
ylim([0 25])
ylim([0 0.9])
xlabel('iteration n','FontSize',10,'FontWeight','bold');
ylabel('x(n)','FontSize',10,'FontWeight','bold');
title('r=3.14','FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
%% r = 3.5
data1=zeros(30,1);data2=zeros(30,1);data3=zeros(30,1);
for r = 3.5
    xn = 0.1;
    for n = 1:30
        xn1 = (r*(xn-xn^2));        
        data1(n) = xn;
        xn=xn1;
    end    
    
    xn = 0.2;
    for n = 1:30
        xn1 = (r*(xn-xn^2));        
        data2(n) = xn;
        xn=xn1;
    end    
    
    xn = 0.3;
    for n = 1:30
        xn1 = (r*(xn-xn^2));        
        data3(n) = xn;
        xn=xn1;
    end
end
figure('Color','w','Position',[1410 374 491 338]);
plot (1:30,data1,'bs-','LineWidth',1.5);hold on;
plot (1:30,data2,'rs-','LineWidth',1.5);
plot (1:30,data3,'ks-','LineWidth',1.5);hold off;
legend('x(0)=0.1','x(0)=0.2','x(0)=0.3','Location','southeast')
axis tight;
ylim([0 25])
ylim([0 0.9])
xlabel('iteration n','FontSize',10,'FontWeight','bold');
ylabel('x(n)','FontSize',10,'FontWeight','bold');
title('r=3.5','FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
%% r=2.8
data1=zeros(30,1);data2=zeros(30,1);data3=zeros(30,1);
for r = 2.8
    xn = 0.1;
    for n = 1:30
        xn1 = (r*(xn-xn^2));
        data1(n) = xn;xn=xn1;        
    end
    
    
    xn = 0.2;
    for n = 1:30
        xn1 = (r*(xn-xn^2));
        data2(n) = xn;xn=xn1;        
    end
    
    
    xn = 0.3;
    for n = 1:30
        xn1 = (r*(xn-xn^2));
        data3(n) = xn;xn=xn1;        
    end
end
figure('Color','w','Position',[1410 374 491 338]);
plot (1:30,data1,'bs-','LineWidth',1.5);hold on;
plot (1:30,data2,'rs-','LineWidth',1.5);
plot (1:30,data3,'ks-','LineWidth',1.5);hold off;
legend('x(0)=0.1','x(0)=0.2','x(0)=0.3','Location','southeast')
axis tight;
ylim([0 25])
ylim([0 0.8])
xlabel('iteration n','FontSize',10,'FontWeight','bold');
ylabel('x(n)','FontSize',10,'FontWeight','bold');
title('r=2.8','FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');