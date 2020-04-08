function calculate_psnr_core(SEQ_FILE, SEQ_WID, SEQ_HEI, DUMP_PREFIX, FRAME_LEN)

fp_ori = fopen([SEQ_FILE   , '.yuv'], 'r');
fp_rec = fopen([DUMP_PREFIX, '.yuv'], 'r');

% fprintf('    Y          U          V\n');
f = 1;
while f <= FRAME_LEN
    % read ori
    ori_y4 = fread(fp_ori, SEQ_WID  *SEQ_HEI  , 'uint8');
    ori_u2 = fread(fp_ori, SEQ_WID/2*SEQ_HEI/2, 'uint8');
    ori_v2 = fread(fp_ori, SEQ_WID/2*SEQ_HEI/2, 'uint8');
    if isempty(ori_v2)
        break;
    end
    % reformat
    ori_y4 = reshape(ori_y4, SEQ_WID  , SEQ_HEI  );
    ori_u2 = reshape(ori_u2, SEQ_WID/2, SEQ_HEI/2);
    ori_v2 = reshape(ori_v2, SEQ_WID/2, SEQ_HEI/2);
    ori_yuv = zeros(SEQ_HEI, SEQ_WID, 3);
    ori_yuv(:      ,:      ,1) = ori_y4';
    ori_yuv(1:2:end,1:2:end,2) = ori_u2';
    ori_yuv(1:2:end,2:2:end,2) = ori_u2';
    ori_yuv(2:2:end,1:2:end,2) = ori_u2';
    ori_yuv(2:2:end,2:2:end,2) = ori_u2';
    ori_yuv(1:2:end,1:2:end,3) = ori_v2';
    ori_yuv(1:2:end,2:2:end,3) = ori_v2';
    ori_yuv(2:2:end,1:2:end,3) = ori_v2';
    ori_yuv(2:2:end,2:2:end,3) = ori_v2';
    %% display
    %ori_yuv = uint8(ori_yuv);
    %ori_rgb = ycbcr2rgb(ori_yuv);
    %imshow(ori_rgb);

    % read rec
    rec_y4 = fread(fp_rec, SEQ_WID  *SEQ_HEI  , 'uint8');
    rec_u2 = fread(fp_rec, SEQ_WID/2*SEQ_HEI/2, 'uint8');
    rec_v2 = fread(fp_rec, SEQ_WID/2*SEQ_HEI/2, 'uint8');
    if isempty(rec_v2)
        break;
    end
    % reformat
    rec_y4 = reshape(rec_y4, SEQ_WID  , SEQ_HEI  );
    rec_u2 = reshape(rec_u2, SEQ_WID/2, SEQ_HEI/2);
    rec_v2 = reshape(rec_v2, SEQ_WID/2, SEQ_HEI/2);
    rec_yuv = zeros(SEQ_HEI, SEQ_WID, 3);
    rec_yuv(:      ,:      ,1) = rec_y4';
    rec_yuv(1:2:end,1:2:end,2) = rec_u2';
    rec_yuv(1:2:end,2:2:end,2) = rec_u2';
    rec_yuv(2:2:end,1:2:end,2) = rec_u2';
    rec_yuv(2:2:end,2:2:end,2) = rec_u2';
    rec_yuv(1:2:end,1:2:end,3) = rec_v2';
    rec_yuv(1:2:end,2:2:end,3) = rec_v2';
    rec_yuv(2:2:end,1:2:end,3) = rec_v2';
    rec_yuv(2:2:end,2:2:end,3) = rec_v2';
    %% display
    %rec_yuv = uint8(rec_yuv);
    %rec_rgb = ycbcr2rgb(rec_yuv);
    %imshow(rec_rgb);

    % psnr
    for c = 1:3
        MSE       = sum(sum((rec_yuv(:,:,c)-ori_yuv(:,:,c)).^2)) / (SEQ_WID*SEQ_HEI);
        PSNR(f,c) = 20*log10(255/sqrt(MSE));
        fprintf('\t %-7.3f', PSNR(f,c));
    end
    fprintf('\n');

    % update counter
    f = f + 1;
end

fprintf('\t %-7.3f \t %-7.3f \t %-7.3f \t mean\n', mean(PSNR(:,:)));

fclose(fp_rec);
fclose(fp_ori);






























