clc;
clear;

%==========================================================================
% Pelatihan JST Probabilistik
% Studi kasus: Penerimaan pegawai
% Input:
%   gb: batas bawah interval konstanta gain (pengontrol)
%   ga: batas atas interval konstanta gain (pengontrol)
%   kuantisasi: tingkat kuantisasi dalam interval gain
% Output:
%   Grafik akurasi pada Train Set dan Test Set terhadap konstanta g
%==========================================================================

function PNNTrain(gb,ga,kuantisasi)

Ptrain = ...
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
  
JPtrain = length(Ptrain(:,1));  
 
Ttrain = ...
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
     
 Ptest = ...
    [3 3 1;
    3 1 2;
    2 3 1;
    2 1 2;
    1 3 1;
    1 2 2;
    1 1 1;];
    
 JPtest = length(Ptest(:,1));   
    
 Ttest = [0 1 0 1 0 1 0]';
 
%----------------------------------------------------------------------------
% TAHAP PERTAMA:
% - Pembentukan unit-unit pola yang di kelompokkan sesuai kelasnya 
% - penghitungan jumlah pola pada masing-masing kelas
%---------------------------------------------------------------------------- 

 P0 = ...
   [3 1 1;
    2 1 1;
    1 2 1];
    
 P1 = ...
   [3 3 2;
    3 2 2;
    3 2 1;
    2 3 2;
    2 2 2;
    2 2 1;
    1 3 2;
    1 1 2];
     
 JP0 = length(P0(:,1))   % Jumlah semua pola latih (11)
 JP1 = length(P1(:,1))
 
%----------------------------------------------------------------------------
% TAHAP KEDUA:
% - Penghitungan total jarak terdekat antara masing-masing pola
%   terhadap pola-pola lainnya dalam satu kelas 
% - penghitungan smoothing parameter untuk setiap kelas
%---------------------------------------------------------------------------- 

TMD0 = GetTMD(P0);
TMD1 = GetTMD(P1);
m = length(P0(1,:));
AllAkurasi = [];

for g=gb:kuantisasi:ga,
    %------------------------------
    % Penghitungan smoothing parameter
    %------------------------------
    SP0 = (g*TMD0) / JP0;
    SP1 = (g*TMD1) / JP1;
    DAkurasi = [];
    for pp=1:2,
      if pp==1,
          P = Ptrain;
          JP = JPtrain;
          T = Ttrain;
      else
          P = Ptest;
          JP = JPtest;
          T = Ttest;
      end
      JumBenar = 0;
      
      for ii=1:JP,
          pegawai = P(ii,:);
          
          %---------------------------------
          % Penghitungan probabilitas pada kelas 0
          %---------------------------------
          prob = [];  % 1 - D Vektor probabilitas
          temp = 0;
          
          for jj=1:JP0,
              delta = exp(-(norm(pegawai-P0(jj,:)) / (2*(SP0^2))));
              temp = temp + delta;
          end    
          prob = [ prob temp / (((2*pi)^(m/2)) * (SP0^m) * JP0) ];
          
          %---------------------------------
          % Penghitungan probabilitas pada kelas 1
          %---------------------------------
          
          temp = 0;
          for jj=1:JP1,
              delta = exp(-(norm(pegawai-P1(jj,:)) / (2*(SP1^2))));
              temp = temp + delta;
          end    
          prob = [ prob temp / (((2*pi)^(m/2)) * (SP1^m) * JP1) ];
          
          %---------------------------------
          % mencari probabilitas terbesar untuk 
          % mendapatkan kelas keputusan
          %---------------------------------
    
          pmax = find(prob==max(prob));
          if length(pmax) > 1,
              pmax = pmax(1);
          end
      
          if pmax == 1,
              keputusan = 0;
          end
          
          if pmax == 2,
              keputusan = 1;
          end
      
          if keputusan == T(ii),
              JumBenar = JumBenar + 1;
          end
       
       end
       Akurasi = JumBenar / JP;
       DAkurasi = [ DAkurasi Akurasi ];
       
    end
    AllAkurasi = [AllAkurasi; DAkurasi];
end

gvar = [gb:kuantisasi:ga];
figure
plot(gvar, AllAkurasi(:,1), 'k-', gvar, AllAkurasi(:,2), 'k:')
axis([gb ga 0 1.2])
legend('Train Set', 'Test Set')
title('Akurasi JST Probabilistik dengan beberapa variasi konstanta g')
xlabel('konstanta g')
ylabel('Akurasi')

save AllAkurasi.m AllAkurasi
save PNNTrainRes.m P0 P1 JP0 JP1 TMD0 TMD1 m