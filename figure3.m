function figure3

clc;
close all;
clearvars;

N=128;
tau=(-1:2/N:1-2/N); %lag value
CS_TF=[];TF=[];
Nk=(N)/2;
n=-Nk:Nk-1;
b=0;


 
ind = 1;
t1=-.5; t2=.5; M=45;  

for t=t1:2/N:t2
        b=b+1;
    q=randperm(N);q1=q(1:N-M);
    q=randperm(N);q2=q(1:N-M);
    q=randperm(N);q3=q(1:N-M);
    q=randperm(N);q4=q(1:N-M);


    
    x1=sig(t+.675*tau,ind).^2;
    x2=conj(sig(t-.675*tau,ind).^2);
    x3=conj(sig(t+.85*tau,ind));
    x4=sig(t-.85*tau,ind);

        
    x1(q1)=0;x2(q2)=0;x3(q1)=0;x4(q2)=0;

    rxx=x1.*x2.*x3.*x4;

    for k=-Nk:Nk-1
        r=rxx.*exp(-j*2*pi*n*k/N);
        X(1,k+Nk+1)=sum(r);    
    end
    %creating dft matrix
    B=dftmtx(N);

    %Selecting random rows of the DFT matrix
    qy=find(rxx~=0);

    %creating measurement matrix
    A=B(qy,:);
    y1=(rxx(qy));

    %Running one iteration kk=1 of the OMP algorithm

    res = y1';
    omega = [];
    kk=1;
    for iter=1:kk,

        yp = A'*res; 
        yp(omega) = 0;
        [jj,ii] = max(abs(yp));
        omega = union(omega,ii);
        a1 = A(:,omega);
        xp = pinv(a1)*y1';     
        res = y1' - a1*xp; 

    end

    xp1 = zeros(N,1);
    xp1(omega) = xp;

    %recovered signal in time domain
    f1=(B*xp1);

    X(2,1:length(f1))=fftshift(fft(flipud(f1)));

    TF(b,:)=X(1,:)';  %% standard representation with missing samples
    CSTF(b,:)=X(2,:)';  %% Compressive sensing base representation

end


figure,
subplot(2,2,1), imagesc(abs(TF)), axis xy, colormap(1-gray), xlabel({'Time samples', '(a)'}), ylabel('Frequency samples'),
subplot(2,2,2), imagesc(abs(CSTF)), axis xy, colormap(1-gray), xlabel({'Time samples', '(b)'}), ylabel('Frequency samples'),


ind = 2;
t1=-1; t2=1; M=50;


for t=t1:2/N:t2
    b=b+1;
    q=randperm(N);q1=q(1:N-M);
    q=randperm(N);q2=q(1:N-M);
    q=randperm(N);q3=q(1:N-M);
    q=randperm(N);q4=q(1:N-M);


    x1=sig(t+tau/4,ind);
    x2=sig(t-tau/4,ind).^(-1);
    x3=(sig(t+j*tau/4,ind).^(-j));
    x4=sig(t-j*tau/4,ind).^j;


    x1(q1)=0;x2(q2)=0;x3(q1)=0;x4(q2)=0;

    rxx=x1.*x2.*x3.*x4;

    for k=-Nk:Nk-1
        r=rxx.*exp(-j*2*pi*n*k/N);
        X(1,k+Nk+1)=sum(r);    
    end
    %creating dft matrix
    B=dftmtx(N);

    %Selecting random rows of the DFT matrix
    qy=find(rxx~=0);

    %creating measurement matrix
    A=B(qy,:);
    y1=(rxx(qy));

    %Running one iteration kk=1 of the OMP algorithm

    res = y1';
    omega = [];
    kk=1;
    for iter=1:kk,

        yp = A'*res; 
        yp(omega) = 0;
        [jj,ii] = max(abs(yp));
        omega = union(omega,ii);
        a1 = A(:,omega);
        xp = pinv(a1)*y1';     
        res = y1' - a1*xp; 

    end

    xp1 = zeros(N,1);
    xp1(omega) = xp;

    %recovered signal in time domain
    f1=(B*xp1);

    X(2,1:length(f1))=fftshift(fft(flipud(f1)));

    TF(b,:)=X(1,:)';  %% standard representation with missing samples
    CSTF(b,:)=X(2,:)';  %% Compressive sensing base representation

end

subplot(2,2,3), imagesc(abs(TF)), axis xy, colormap(1-gray), xlabel({'Time samples', '(c)'}), ylabel('Frequency samples'),
subplot(2,2,4), imagesc((abs(CSTF))), axis xy, colormap(1-gray), xlabel({'Time samples', '(d)'}), ylabel('Frequency samples'),

end

function x=sig(t,ind)
  
if (ind==1)
x=exp(j*160*pi*t.^3-0*j*56*pi*t.^2-j*192*pi*t);  %% for PD

else

x=exp(j*6*sin(2.4*pi*t)+j*3*cos(1.5*pi*t)-1*j*20*pi*t.^2); %% for CTD

end

end


