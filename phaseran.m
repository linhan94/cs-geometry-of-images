function surrblk = phaseran(recblk,nsurr)
    [nfrms,nts] = size(recblk);
    if rem(nfrms,2)==0
        nfrms = nfrms-1;
        recblk=recblk(1:nfrms,:);
    end

    % Get parameters
    len_ser = (nfrms-1)/2;
    interv1 = 2:len_ser+1; 
    interv2 = len_ser+2:nfrms;

    % Fourier transform of the original dataset
    fft_recblk = fft(recblk);

    % Create the surrogate recording blocks one by one
    surrblk = zeros(nfrms, nts, nsurr);
    for k = 1:nsurr
       ph_rnd = rand([len_ser 1]);

       % Create the random phases for all the time series
       ph_interv1 = repmat(exp( 2*pi*1i*ph_rnd),1,nts);
       ph_interv2 = conj( flipud( ph_interv1));

       % Randomize all the time series simultaneously
       fft_recblk_surr = fft_recblk;
       fft_recblk_surr(interv1,:) = fft_recblk(interv1,:).*ph_interv1;
       fft_recblk_surr(interv2,:) = fft_recblk(interv2,:).*ph_interv2;

       % Inverse transform
       surrblk(:,:,k)= real(ifft(fft_recblk_surr));
    end
end