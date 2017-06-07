clc;
clear;

%==========================================================================
% Pengujian JST Probabilistik
% Studi kasus: Penerimaan pegawai
% Input:
%   TestSet: data data pegawai yang belum pernah di latih
% Output:
%   Akurasi: Akurasi pengklasifikasian diterima atau ditolak
%==========================================================================

function PNNTest(g)

PNNTrainRes
     
TestSet = ...
    [3 3 1;
    3 1 2;
    2 3 1;
    2 1 2;
    1 3 1;
    1 2 2;
    1 1 1;];
    
 JTestSet = length(TestSet(:,1));   
    
 TestTarget = [0 1 0 1 0 1 0]';

 Lakurasi = [];
 JumBenar = 0;
 Akurasi = 0;
 
    %------------------------------
    % Penentuan smoothing parameter
    %------------------------------
    SP0 = (g*TMD0) / JP0;
    SP1 = (g*TMD1) / JP1;

      for ii=1:JTestSet,
          pegawai = TestSet(ii,:);
          
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
      
          if keputusan == TestTarget(ii),
              JumBenar = JumBenar + 1;
          end
       
       end
       Akurasi = JumBenar / JTestSet;