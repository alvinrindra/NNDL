%===========================================================================
% Fungsi untuk menghitung total jarak terdekat dari masing-masing
% pola terhadap pola lain dalam kelas yang sama.
% Input:
%   P: Kumpulan pola dalam satu kelas
% Output:
%   TMD: Total Minimum Distance (Total jarak terdekat)
% 
%===========================================================================

function TMD = GetTMD(P)

JP = length(P(:,1));
TMD = 0;

for ii=1:JP,
    MD=10^10;    
    for jj=1:JP,
      if ii ~= jj,
        D = norm(P(ii,:)-P(jj,:));
        if D < MD,
          MD = D;
        end
      end
    end
    TMD = TMD + MD;
end

%==========================================================================