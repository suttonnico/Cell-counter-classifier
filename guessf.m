function [ Y ] = guessf( C )


BW = im2bw(C, 0.5);

%BW = imclearborder(BW);

 SX=[-1,0,1;-2,0,2;-1,0,1];         
 SY=[-1,-2,-1;0,0,0;1,2,1];
 GX=conv2(SX,double(BW(:,:,1)));
 GY=conv2(SY,double(BW(:,:,1)));
 G=sqrt(GX.^2+GY.^2);
 G = im2bw(G, 0.5);
%imshow(G)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%weights=matfile('weights.mat');
sum(sum(G))
if(sum(sum(G))<840)
    Y=1;
else
    Y=2;
end

end

