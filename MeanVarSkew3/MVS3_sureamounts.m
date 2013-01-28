function MVS3_sureamounts(n,sure_amounts)
%creates sprites with text saying 'sure amount for next 'n' trials = 
%n is the number of trials per target
%output sprites are 
%Mkael Symmonds 18-6-9, adapted for NSPN Feb 2011


sprite_count=20;   %this is the number from which the sprite number is initialised
sprite_wid = 350;
sprite_high = 350;
sprite_fontsize = 16;

for i=1:length(sure_amounts)
    cgmakesprite(sprite_count,sprite_wid,sprite_high,0,0,0);
    cgsetsprite(sprite_count);
    cgpencol(1,1,1); %white pen
    cgfont('Arial', sprite_fontsize);
    text=['确定金额 以下 ', n,' 次 = '];
    cgtext(text, 0, sprite_fontsize);
    cgtext(['  元 ' num2str(sure_amounts(i))],0,-sprite_fontsize);
    cgsetsprite(0);
    sprite_count = sprite_count +1;
end
