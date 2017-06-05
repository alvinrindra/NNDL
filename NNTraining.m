%===========================================================================
% Training program with back propagration to train MLP
% Variable yang dapat di update
% 1. JHneuron
% 2. Learning Rate
% 3. Epoch
% 4. MaxMSE
%===========================================================================

clc;
clear;

P = ...
    [3 3 2; %P1
    3 2 2;
    3 2 1;
    3 1 1;
    2 3 2;
    2 2 2;
    2 2 1;
    2 1 1;
    1 3 2;
    1 2 1;
    1 1 2]; %P11
    
 T = ...
    [1;
     1;
     1;
     0;
     1;
     1;
     1;
     0;
     1;
     0;
     1];
     
 JumPola = length(P(:,1))   % Jumlah semua pola latih (11)
 DimPola = length(P(1,:))   % Dimensi Pola latih (3)
 JOneuron = length(T(1,:))  % Jumlah neurons pada output layer (1)

 JHneuron = 10;               % Jumlah neurons pada Hidden Layer
 LR = 0.5;                   % Learning Rate
 Epoch = 20000;               % Maksimum iteration
 MaxMSE = 10^-5;             % Maksimum Mean Square Error (MSE)

%----------------------------------------------------------------------------
% Bangkitkan Weights antara Input Layer dan Hidden layer secara acak dalam interval 
% -1 through +1. Simpan sebagai W1.
%----------------------------------------------------------------------------

W1 = [];
for ii=1:JHneuron,
    W1 = [W1 ; (rand(1, DimPola)*2-1)];
end
W1 = W1';

%----------------------------------------------------------------------------
% Call the weights among Hidden Layer and output layer randomly between interval -1
% through +1. W2.
%----------------------------------------------------------------------------

W2 = [];
for jj=1:JOneuron,
    W2 = [W2 ; (rand(1, JHneuron)*2-1)];
end
W2 = W2';

MSEepoch = MaxMSE + 1;        % Mean Square Error untuk 1 epoch
MSE = [];                     % List MSE untuk seluruh epoch
ee = 1;                       % Index Epoch


while ( ee <= Epoch ) & ( MSEepoch > MaxMSE ),
  MSEepoch = 0;
  for pp=1:JumPola,
      CP = P(pp,:);           % Current Pattern
      CT = T(pp,:);           % Current Target
      
      %----------------------------------------------------------------------
      % Perhitungan Maju untuk mendapatkan Output, Error, dan MSE
      %----------------------------------------------------------------------      
      A1 = [];
      for ii=1:JHneuron,
          v = CP * W1(:,ii);
          A1 = [A1 1/(1+exp(-v))];
      end
      
      A2 = [];
      for jj=1:JOneuron,
          v = A1 * W2(:,jj);
          A2 = [A2 1/(1+exp(-v))];
      end
      Error = CT - A2;
      
      for kk=1:length(Error),
        MSEepoch = MSEepoch + Error(kk)^2;
      end
      
      %----------------------------------------------------------------------
      % Perhitungan Mundur untuk meng-update W1 dan W2
      %----------------------------------------------------------------------      
      for kk=1:JOneuron,
          D2(kk) = A2(kk) * (1-A2(kk)) * Error(kk);
      end
      
      dW2 = [];
      for jj=1:JHneuron,
        for kk=1:JOneuron,
          delta2(kk) = LR * D2(kk) * A1(jj);
        end
        dW2 = [ dW2 ; delta2 ];
      end
      for jj=1:JHneuron,
          D1(jj) = A1 * (1-A1)' * D2 * W2(jj,:)';
      end
      dW1 = [];
      for ii=1:DimPola,
        for jj=1:JHneuron,
            delta1(jj) = LR * D1(jj) * CP(ii);
        end
        dW1 = [ dW1 ; delta1 ];
      end
      W1 = W1 + dW1;                % W1 baru
      W2 = W2 + dW2;                % W2 baru
   end
   
   ee++;
 
   MSE = [ MSE (MSEepoch/JumPola) ];
end

plot(MSE);
xlabel('Epoch')
ylabel('MSE')
    





