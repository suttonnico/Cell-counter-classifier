function [ output_args ] = foundborder( G)
V=zeros(size(G));
[M,N]=size(G);
O=G;
counter=0;
flag=0;
for k=1:1e100,    %M y N es para tener un número máximo nada mas 
    %mi idea es que siga el borde hasta poneindo en la matriz V si visito
    %ese pixel o no y cuando se encuentra con un pixel que ya visito es que
    %le dio la vuelta a la celula y podríamos sacar información como area
    %de la celula y donde esta el medio de la celula para después ver si es
    %que se esta dividiendo o no
    V=zeros(size(G));
    for j=1:M,
        for l=1:N,
V=zeros(size(G));
            if(G(j,l)==1)
               [V,hx,lx,hy,ly]=visit_pixel(G,j,l,V,0,999999,0,9999,0); 
               
               
               G=G-V;
               if((hx~=0)&&(lx~=0)&&(hy~=0)&&(ly~=0))
                   counter=counter+1;
                   C=V(lx:hx,ly:hy);
                   C=imresize(C,[50,50]);
                   subplot(2,2,2),subimage(C),title('Celula encontrada')
               end
              
               subplot(2,2,1), subimage(G),title('Anterior')
               
               subplot(2,2,3),subimage(G) ,title('Anterior - Celula encontrada')
               subplot(2,2,4),subimage(O),title('Original')
               counter
               break;
            end
        end
    end
    break;
end
    
    
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

counter
end

