classdef celcounter < handle 
    %CELCOUNTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        handles;
        G;
        OG;
        counter1;
        guess;
        guess_list;
        C;
        I;
        width;
        height;
        n;
        ra;
        
    end
    
    methods
        function self = celcounter(~)
            hfig=hgload('celcountergui.fig');
            self.handles=guihandles(hfig);
            movegui(hfig,'center');
            
            set(self.handles.pushbutton_countone,'callback', @self.pushbutton_countone_callback);
            set(self.handles.pushbutton_countall,'callback', @self.pushbutton_countall_callback);
            set(self.handles.pushbutton_yes,'callback', @self.pushbutton_yes_callback);
            set(self.handles.pushbutton_no,'callback', @self.pushbutton_no_callback);
            %inicio variables
            self.n=0;
            self.width=[];
            self.height=[];
            self.ra=[];
            self.counter1=0;
            self.I = imread('plant_cell_mitosis.jpg');
            BW = im2bw(self.I, 0.5);
            BW = ~BW;
            %BW = imclearborder(BW);
            %[labeledImage, numberOfCircles] = bwlabel(BW);
            SX=[-1,0,1;-2,0,2;-1,0,1];
            SY=[-1,-2,-1;0,0,0;1,2,1];
            GX=conv2(SX,double(BW(:,:,1)));
            GY=conv2(SY,double(BW(:,:,1)));
            self.G=sqrt(GX.^2+GY.^2);
            self.G = im2bw(self.G, 0.5);
            imshow(self.I,'parent',self.handles.axes1)


        end
        function pushbutton_countall_callback(self,varargin)

            while 1
                if isempty(self.G) ~= 1
                    pushbutton_countone_callback(self);
                    pause(0.001)                        %es para que no se rompa matlab
                else
                    break;
                end
                
            end
        end
        function pushbutton_countone_callback(self,varargin)


            [M,N]=size(self.G);
            flag=0;
            for j=1:M,
                if(flag==1)
                    break;
                end
                for l=1:N,
                    
                    if(self.G(j,l)==1)
                        V=zeros(size(self.G));
                        [V,hy,ly,hx,lx]=visit_pixel(self.G,j,l,V,0,999999,0,9999,0);
                        
                        
                        if((hy~=0)&&(ly~=0)&&(hx~=0)&&(lx~=0)&&(hx-lx>15)&&(hy-ly>15))
                            flag=1;
                            self.guess=guessf(imresize(V(ly:hy,lx:hx),[50,50]));
                            V(ly:hy,lx:hx)=self.G(ly:hy,lx:hx);
                            self.G=self.G-V;
                            %DEJE ACA HACER QUE AGARRE G((ly:hy,lx:hx)
                            self.counter1=self.counter1+1;
                            self.C=V(ly:hy,lx:hx);
                            self.C=imresize(self.C,[50,50]);
                           
                            imshow(self.C,'parent',self.handles.axes2)
                            im2show=self.I;
                            if lx>1
                                im2show(ly:hy,lx-1:lx+1,:)=zeros(size(im2show(ly:hy,lx-1:lx+1,:)));
                            end
                                im2show(ly:hy,hx-1:hx+1,:)=zeros(size(im2show(ly:hy,hx-1:hx+1,:)));
                            if ly>1
                                im2show(ly-1:ly+1,lx:hx,:)=zeros(size(im2show(ly-1:ly+1,lx:hx,:)));
                            end
                            im2show(hy-1:hy+1,lx:hx,:)=zeros(size(im2show(hy-1:hy+1,lx:hx,:)));
                            %size(im2show)
                            imshow(im2show,'parent',self.handles.axes1)
                            
                            s=self.guess;
                            self.guess_list=[self.guess_list,s];
                            switch s
                                case 1
                                    set(self.handles.guess_text,'String','Interfase');
                                case 2
                                    set(self.handles.guess_text,'String','Mitosis');
                                    
                            end 
                            self.n=self.n+1;
                            %para simplificar hago que siempre la dirección
                            %más larga sea la altura
                            if hy-ly>hx-lx
                                self.height=[self.height,hy-ly];
                                self.width=[self.width,hx-lx];
                            else
                                self.height=[self.height,hx-lx];
                                self.width=[self.width,hy-ly];
                            end
                            self.ra=[self.ra,self.width/self.height];
                            mean(self.width)*mean(self.height)
                            p=stem([1,2],[mean(self.guess_list)-1,1-(mean(self.guess_list)-1)]*100);
                            set(p,'Parent', self.handles.axes3)
                            axis([0 3 0 110])
                            set(gca,'xticklabel',{' ';' ';'mitosis';' ';'interfase';' ';' '})
                           
                                
                       
                            
                            
                            set(self.handles.face_text,'String','...');
                            break;
                            
                        else self.G=self.G-V;
                        end
                        


                           

                    end
                end
            end
            
        end
       
    end
    
end

