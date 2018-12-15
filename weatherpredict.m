%main file
%Created by Zheng Tian

load weatherdata.mat

% the prediction is based on the past and current DAYS_BCK count of days
DAYS_BCK=1;
% the preiction will be DAYS_FWD days ahead of the current day
DAYS_FWD=1;
% variable TARG contains the data to be predicted
TARG=TEMPxNORMAL(12,:);
% variable LABEL contains a string to describe the prediction target
LABEL='Temperature (Noon-1PM)';
% variable FEAT contains the data that is used to base the prediction on
FEAT=[TEMPxNORMAL(12,:)];
% FEAT=[TEMPxNORMAL(9:15,:);DEWPxNORMAL(9:15,:);WINDxAVGSPD(9:15,:)];

% define the start day of prediction
DAY_START=1+DAYS_BCK+DAYS_FWD;

% generate the feature difference array
FDIF=[]; for n=1:size(FEAT,1); FDIF=[ FDIF ; diff(FEAT(n,:)) ]; end

% generate the target difference array
TDIF=[0,diff(TARG)];

% generate the feature vectors
FVEC=zeros(size(FDIF,1)*DAYS_BCK,362-DAY_START+1);
n=1; for k=DAY_START:362;
    % generate the backward feature index
    idx=k-DAYS_FWD-DAYS_BCK:k-DAYS_FWD-1;
    % extract the feature segment
    V=FDIF(:,idx).'; FVEC(:,k-DAY_START+1)=V(:);
end

% generate the target values
TVAL=TDIF(DAY_START:362);

% generate zero-mean feature vectors for the covariance estimate
XY=[ TVAL ; FVEC ]; XY=XY-repmat(mean(XY,2),1,size(XY,2));

% estimate the inverse covariance matrix
D=invcovmat(XY);

% initialize the prediction vector
PVAL=zeros(1,size(FVEC,2));

% compute the prediction estimate
for k=1:size(FVEC,2); PVAL(k)=gaussmap(FVEC(:,k),D); end

% reintroduce the mean value
PVAL=PVAL+mean(TVAL);

% generate the list of considered days
dd=DAY_START:362;

% reconstruct the predicted value
PRED=TARG(dd-1)+PVAL;

% generate the output figure
figure(1);
set(gcf,'Name',...
    'Caution: Prediction Errors Computed over Training Data!',...
    'NumberTitle','off')

% plot the target data
subplot(2,1,1);
xplot(dd,TARG(dd),'buckred'); set(gca,'FontSize',12);
ylabel(LABEL); xlabel('Day Count');
title(LOCATION);

% plot the prediction results
subplot(2,1,2);
xplot(dd,abs(TARG(dd-1)-TARG(dd)),'buckorange'); hold on
xplot(dd,abs(PRED-TARG(dd)),'buckblue'); hold off
set(gca,'FontSize',12); axis([dd(1) dd(end) -0.1 0.9 ]);
title(['PREDICTION ERROR ( ',num2str(DAYS_FWD),' Day(s) Forward )']);
xlabel('Day Count'); ylabel('Prediction Error');
ER1=num2str(mean(abs(PRED-TARG(dd))));
ER2=num2str(mean(abs(TARG(dd-1)-TARG(dd))));
legend(['Previous Day Value [ Av.Error = ',ER2,' ]'],...
    ['Gaussian MAP Estimate [ Av.Error = ',ER1,' ]']);
