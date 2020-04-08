%=== INIT ======================================================================
clear;
clc;
close all;
hold off;

KNOB_USE_MAT = 0;
NAME_DIR_SRC = '../JohnnyA0TestExtraChroma/dump/Johnny_22';    % sequence Johnny is recommended
NAME_DIR_DST = 'dump';
SIZE = [4, 8, 16, 32];
INDX_CST = 3;




%=== MAIN BODY =================================================================
for siz = SIZE
    %--- GET DATA --------------------------
    if KNOB_USE_MAT
        load([NAME_DIR_SRC,'/','data_',num2str(siz, '%02d'),'.mat']);
    else
        for idxChn = 1:3
            switch idxChn
                case 1
                    datChn = 'y';
                    sizTrue = siz;
                case 2
                    datChn = 'u';
                    sizTrue = max(4, siz/2);
                case 3
                    datChn = 'v';
                    sizTrue = max(4, siz/2);
            end
            fptCoe = fopen([NAME_DIR_SRC,'/','rdo_cst_coe_',num2str(siz, '%02d'),'_',datChn,'_I16F0S1.dat'], 'r');
            datCoe = fscanf(fptCoe, '%x');
            fclose(fptCoe);
            datCoe(datCoe>=2^15) = datCoe(datCoe>=2^15) - 2^16;
            %                         x        y        num
            datCoe = reshape(datCoe', sizTrue, sizTrue, []);
            switch idxChn
                case 1
                    datCoeY = datCoe;
                case 2
                    datCoeU = datCoe;
                case 3
                    datCoeV = datCoe;
            end
        end
        for idxTyp = 1:2
            switch idxTyp
                case 1
                    datTyp = 'lu';
                case 2
                    datTyp = 'ch';
            end
            fptBit = fopen([NAME_DIR_SRC,'/','rdo_cst_bit_',num2str(siz, '%02d'),'_',datTyp,'_I32F0S0.dat'], 'r');
            datBit = fscanf(fptBit, '%x');
            %                        i, num
            datBit = reshape(datBit, 3, []);
            switch idxTyp
                case 1
                    datBitLu = datBit;
                case 2
                    datBitCh = datBit;
            end
            fclose(fptBit);
        end
        save([NAME_DIR_SRC,'/','data_',num2str(siz, '%02d'),'.mat'])
    end


    %--- CORE LOOP ---------------------------------
    for idxTyp = 1:2
        %--- PREPARE DATA ---
        switch idxTyp
            case 1
                [~, num] = size(datBitLu);
                sizTrue = siz;
                datTyp = 'lu';
            case 2
                [~, num] = size(datBitCh);
                sizTrue = max(4, siz/2);
                datTyp = 'ch';
        end
        datWeight = ones(sizTrue, sizTrue);
        datFitX = ones(1, num);
        datFitY = ones(1, num);
        for x = 1:sizTrue
            for y = 1:sizTrue
                % datWeight(x, y) = 1;
                % datWeight(x, y) = max(x-1, y-1) + 1;
                datWeight(x, y) = x-1 + y-1 + 1;
                % datWeight(x, y) = (x-1) * (y-1) + 1;
                % datWeight(x, y) = mod(x-1,4) + mod(y-1,4) + 1;
            end
        end
        for i = 1:num
            switch idxTyp
                case 1
                    datFitX(i) = sum(sum(abs(datCoeY(:,:,i)) .* datWeight)) / sum(sum(datWeight));
                    datFitY(i) = sum(datBitLu(INDX_CST,i)) / sizTrue^2 / 2^15;
                case 2
                    datFitX(i) = sum(sum(abs(datCoeU(:,:,i)) .* datWeight)) / sum(sum(datWeight))    ...
                        +        sum(sum(abs(datCoeV(:,:,i)) .* datWeight)) / sum(sum(datWeight));
                    datFitX(i) = datFitX(i) / 2;
                    datFitY(i) = sum(datBitCh(INDX_CST,i)) / sizTrue^2 / 2^15;
                    datFitY(i) = datFitY(i) / 2;
            end
        end

        %--- FILTER ---
        datFitY = datFitY(datFitX<1);
        datFitX = datFitX(datFitX<1);

        %--- FIT DATA V0 ---
        %rltFit = polyfit(datFitX, datFitY, 1);
        %datRepY = polyval(rltFit, datFitX);

        %--- FIT DATA V1 ---
        [datFitXCurve, datFitYCurve] = prepareCurveData(datFitX, datFitY);
        hdlFit = fittype('a * x ^ 0.5 + c', 'independent', 'x', 'dependent', 'y');
        hdlOpt = fitoptions( 'Method', 'NonlinearLeastSquares' );
        hdlOpt.Display = 'Off';
        hdlOpt.StartPoint = [2.5 0];
        [rltFitCoe, rltFitErr] = fit(datFitXCurve, datFitYCurve, hdlFit, hdlOpt);
        datRepY = rltFitCoe.a * datFitX .^ 0.5 + rltFitCoe.c;
        fprintf('size :  %02d\n', siz);
        fprintf('type :  %02s\n', datTyp);
        fprintf('a    :  %.2f\n', rltFitCoe.a);
        fprintf('c    :  %.2f\n', rltFitCoe.c);
        fprintf('rmse :  %.4f\n', rltFitErr.rmse);
        fprintf('\n');

        %--- FIT DATA V2 ---
        %[datFitXCurve, datFitYCurve] = prepareCurveData(datFitX, datFitY);
        %hdlFit = fittype('a * x + b * x ^ 0.5 + c', 'independent', 'x', 'dependent', 'y');
        %hdlOpt = fitoptions( 'Method', 'NonlinearLeastSquares' );
        %hdlOpt.Display = 'Off';
        %hdlOpt.StartPoint = [0.5 2.5 0];
        %[rltFitCoe, rltFitErr] = fit(datFitXCurve, datFitYCurve, hdlFit, hdlOpt);
        %datRepY = rltFitCoe.a * datFitX + rltFitCoe.b * datFitX.^0.5 + rltFitCoe.c;
        %fprintf('a    :  %.2f\n', rltFitCoe.a);
        %fprintf('b    :  %.2f\n', rltFitCoe.b);
        %fprintf('c    :  %.2f\n', rltFitCoe.c);
        %fprintf('rmse :  %.4f\n', rltFitErr.rmse);

        %--- SHOW RESULT ---
        figure(idxTyp)
        hold off;
        plot(datFitX, datFitY, '.');
        hold on;
        plot(datFitX, datRepY, '.');

        %--- SAVE RESULT ---
        fpt = fopen([NAME_DIR_DST, '/', num2str(siz, '%02d'), '_', datTyp,'.txt'], 'w');
        fprintf(fpt, 'size :  %02d\n', siz);
        fprintf(fpt, 'type :  %02s\n', datTyp);
        fprintf(fpt, 'a    :  %.2f\n', rltFitCoe.a);
        try
            fprintf(fpt, 'b    :  %.2f\n', rltFitCoe.b);
        end
        fprintf(fpt, 'c    :  %.2f\n', rltFitCoe.c);
        fprintf(fpt, 'rmse :  %.4f\n', rltFitErr.rmse);
        fclose(fpt);
        fra = getframe(gcf);
        img = frame2im(fra);
        title(['size: ', num2str(siz, '%02d'), '; type: ', datTyp]);
        imwrite(img, [NAME_DIR_DST, '/', num2str(siz, '%02d'), '_', datTyp,'.png']);
    end
end




%=== POST ======================================================================
fclose all;
