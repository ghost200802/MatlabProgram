function Point_Analyse_sure(sig,N,M)
    log_sig = abs(sig)/max(max(abs(sig)));
    log_sig = 20*log10(log_sig+eps);
    lim = [-60 0];
    figure(7);imagesc(log_sig,lim);colormap(gray);
    xlabel('Range');ylabel('Azimuth');
    %*************** select the point target position ****************
    disp('Select the Area');    [n_rg, n_az] = ginput(2);
    n_rg = round(n_rg);          n_az = round(n_az);
    pnt_sig = sig(n_az(1):n_az(2),n_rg(1):n_rg(2));
    figure(7);imagesc(abs(pnt_sig));colormap(gray);
    disp('Select the point target'); [loc_rg, loc_az] = ginput(1);
    loc_rg = round(loc_rg);    loc_az = round(loc_az);
    pnt_sig = sig(n_az(1)+loc_az-N/2:n_az(1)+loc_az+N/2-1,n_rg(1)+loc_rg-N/2:n_rg(1)+loc_rg+N/2-1);
    figure(7);imagesc(abs(pnt_sig));colormap(gray);
    %***************** Pad the spectrum with zeros ********************
    fsig = zeros(N*2,N*2);
    fsig(1:2:end,1:2:end) = pnt_sig;
    fsig = fftshift(fft2(fftshift(fsig)));
    figure(7);imagesc(abs(fsig));colormap(gray);
    mask = roipoly;
    figure(7);imagesc(abs(mask.*fsig));colormap(gray);
    N_pad = N*M;
    sig_pad = zeros(N_pad,N_pad);
    sig_pad(N_pad/2-N:N_pad/2+N-1,N_pad/2-N:N_pad/2+N-1) = mask.*fsig;
    sig_pad = fftshift(ifft2(fftshift(sig_pad)));
    %**************** Contour the padded point ********************
    log_sig_pad = 20*log10((abs(sig_pad)+eps)/max(max(abs(sig_pad))));
    figure;imagesc(log_sig_pad,[-45,0]);axis equal;axis tight;
    figure;contour(log_sig_pad.*(log_sig_pad>-30));axis equal;axis tight;
    [loc_rg, loc_az] = ginput(3); loc_rg = round(loc_rg); loc_az = round(loc_az);
    %*************** Range *****************
    x = 1:N_pad;
    y = round((loc_az(2)-loc_az(1))/(loc_rg(2)-loc_rg(1))*(x-loc_rg(1))+loc_az(1));
    slice_rg = zeros(1,N_pad);
    for iter = 1:N_pad
        slice_rg(iter) = sig_pad(y(iter),x(iter));
    end
    D1_tm = 512/M;
    N_pad_new = N_pad*D1_tm;
    slice_rg_pad = zeros(1,N_pad_new);
    slice_rg_pad((N_pad_new-N_pad)/2:(N_pad_new+N_pad)/2-1) = fftshift(fft(fftshift(slice_rg)));
    slice_rg_pad = fftshift(ifft(fftshift(slice_rg_pad)));
    slice_rg = slice_rg_pad; clear slice_rg_pad;
    [max_val,loc] = max(abs(slice_rg));
    pre_val = max_val;
    cur_val = max_val;
    cnt = 0;
    flag = 1;
    while(pre_val >= cur_val && loc - cnt-1 >0)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(slice_rg(loc-cnt));
    end
    if(loc-cnt-1 == 0)
        flag = 0;
    end
    left_loc = loc-cnt+1;
    pre_val = max_val;
    cur_val = max_val;
    cnt = 0;
    while(pre_val >= cur_val && loc + cnt<=N_pad_new)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(slice_rg(loc+cnt));
    end
    if(loc+cnt-1 == N_pad_new)
        flag = 0;
    end
    right_loc = loc+cnt-1;
    ISLR_rg = sum(abs(slice_rg(left_loc:right_loc)).^2);
    ISLR_rg = 10*log10((sum(abs(slice_rg).^2)-ISLR_rg)/ISLR_rg);
    
    pre_val = abs(slice_rg(left_loc));
    cur_val = pre_val;
    cnt = 0;
    while(pre_val <= cur_val && left_loc - cnt>0)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(slice_rg(left_loc-cnt));
    end
    if(left_loc-cnt-1 == 0)
        flag = 0;
    end
    left_pslr = abs(pre_val);
    
    pre_val = abs(slice_rg(right_loc));
    cur_val = pre_val;
    cnt = 0;
    while(pre_val <= cur_val && right_loc + cnt<=N_pad_new)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(slice_rg(right_loc+cnt));
    end
    if(right_loc+cnt-1 == N_pad_new)
        flag = 0;
    end
    right_pslr = abs(pre_val);
    PSLR_rg = 20*log10(max(right_pslr,left_pslr)/max_val);
    
    pre_val = 3;
    cur_val = 3;
    cnt = 0;
    while(pre_val >= cur_val && loc - cnt-1 >0)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(20*log10(abs(slice_rg(loc-cnt))/max_val)+3);
    end
    if(loc-cnt-1 == 0)
        flag = 0;
    end
    left_3dB_loc_rg = loc-cnt+1;
    left_3dB_rg = 20*log10(abs(slice_rg(left_3dB_loc_rg))/max_val);
    pre_val = 3;
    cur_val = 3;
    cnt = 0;
    while(pre_val >= cur_val && loc + cnt<=N_pad_new)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(20*log10(abs(slice_rg(loc+cnt))/max_val)+3);
    end
    if(loc+cnt-1 == N_pad_new)
        flag = 0;
    end
    right_3dB_loc_rg = loc+cnt-1;
    right_3dB_rg = 20*log10(abs(slice_rg(right_3dB_loc_rg))/max_val);
    disp('------------------------ Range Profile -----------------------')
    disp(strcat('Range PSLR is : ',num2str(PSLR_rg),' dB'));    
    disp(strcat('Range ISLR is : ',num2str(ISLR_rg),' dB'));
    disp(strcat('Range mainlobe width is : ',num2str(right_loc-left_loc+1),' pexels'));
    disp(strcat('Range 3dB mainlobe width is : ',num2str(right_3dB_loc_rg-left_3dB_loc_rg+1),' pexels',' (',num2str(right_3dB_rg),',',num2str(left_3dB_rg),')'));
    disp(strcat('Range flag is : ',num2str(flag)));
    figure;plot(20*log10(abs(slice_rg)/max(abs(slice_rg))));title('Range Slice');xlabel('Range');ylim(lim);
    grid on;axis tight;
    %*************** Azimuth *******************
    y = 1:N_pad;
    x = round((loc_rg(3)-loc_rg(1))/(loc_az(3)-loc_az(1))*(y-loc_az(1))+loc_rg(1));
    slice_az = zeros(1,N_pad);
    for iter = 1:N_pad
        slice_az(iter) = sig_pad(y(iter),x(iter));
    end
    D1_tm = 512/M;
    N_pad_new = N_pad*D1_tm;
    slice_az_pad = zeros(1,N_pad_new);
    slice_az_pad((N_pad_new-N_pad)/2:(N_pad_new+N_pad)/2-1) = fftshift(fft(fftshift(slice_az)));
    slice_az_pad = fftshift(ifft(fftshift(slice_az_pad)));
    slice_az = slice_az_pad; clear slice_az_pad;
    [max_val,loc] = max(abs(slice_az));
    pre_val = max_val;
    cur_val = max_val;
    cnt = 0;
    flag = 1;
    while(pre_val >= cur_val && loc - cnt-1 >0)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(slice_az(loc-cnt));
    end
    if(loc-cnt-1 == 0)
        flag = 0;
    end
    left_loc = loc-cnt+1;
    pre_val = max_val;
    cur_val = max_val;
    cnt = 0;
    while(pre_val >= cur_val && loc + cnt<=N_pad_new)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(slice_az(loc+cnt));
    end
    if(loc+cnt-1 == N_pad_new)
        flag = 0;
    end
    right_loc = loc+cnt-1;
    ISLR_az = sum(abs(slice_az(left_loc:right_loc)).^2);
    ISLR_az = 10*log10((sum(abs(slice_az).^2)-ISLR_az)/ISLR_az);
    
    pre_val = abs(slice_az(left_loc));
    cur_val = pre_val;
    cnt = 0;
    while(pre_val <= cur_val && left_loc - cnt>0)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(slice_az(left_loc-cnt));
    end
    if(left_loc-cnt-1 == 0)
        flag = 0;
    end
    left_pslr = abs(pre_val);
    pre_val = abs(slice_az(right_loc));
    cur_val = pre_val;
    cnt = 0;
    while(pre_val <= cur_val && right_loc + cnt<=N_pad_new)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(slice_az(right_loc+cnt));
    end
    if(right_loc+cnt-1 == N_pad_new)
        flag = 0;
    end
    right_pslr = abs(pre_val);
    PSLR_az = 20*log10(max(right_pslr,left_pslr)/max_val);
    
    pre_val = 3;
    cur_val = 3;
    cnt = 0;
    while(pre_val >= cur_val && loc - cnt-1 >0)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(20*log10(abs(slice_az(loc-cnt))/max_val)+3);
    end
    if(loc-cnt-1 == 0)
        flag = 0;
    end
    left_3dB_loc_az = loc-cnt+1;
    left_3dB_az = 20*log10(abs(slice_az(left_3dB_loc_az))/max_val);
    pre_val = 3;
    cur_val = 3;
    cnt = 0;
    while(pre_val >= cur_val && loc + cnt<=N_pad_new)
        cnt = cnt+1;
        pre_val = cur_val;
        cur_val = abs(20*log10(abs(slice_az(loc+cnt))/max_val)+3);
    end
    if(loc+cnt-1 == N_pad_new)
        flag = 0;
    end
    right_3dB_loc_az = loc+cnt-1;
    right_3dB_az = 20*log10(abs(slice_az(right_3dB_loc_az))/max_val);
    disp('------------------------ Azimuth Profile -----------------------')
    disp(strcat('Azimuth PSLR is : ',num2str(PSLR_az),' dB'));
    disp(strcat('Azimuth ISLR is : ',num2str(ISLR_az),' dB'));
    disp(strcat('Azimuth mainlobe width is : ',num2str(right_loc-left_loc+1),' pexels'));
    disp(strcat('Azimuth 3dB mainlobe width is : ',num2str(right_3dB_loc_az-left_3dB_loc_az+1),' pexels',' (',num2str(right_3dB_az),',',num2str(left_3dB_az),')'));
    disp(strcat('Azimuth flag is : ',num2str(flag)));
    disp('----------------------------------------------------------------')
    figure;plot(20*log10(abs(slice_az)/max(abs(slice_az))));title('Azimuth Slice');xlabel('Azimuth');ylim(lim);
    grid on; axis tight;
end