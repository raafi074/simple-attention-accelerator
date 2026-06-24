module attention_top;

integer X [0:7];
integer WQ [0:15];
integer WK [0:15];
integer WV [0:15];

integer Q [0:7];
integer K [0:7];
integer V [0:7];

integer score [0:3];
integer scaled [0:3];
integer attn [0:3];
integer O [0:7];

integer i, j, k;
integer sum;
integer f;

initial begin
    $readmemh("data/x.mem", X);
    $readmemh("data/wq.mem", WQ);
    $readmemh("data/wk.mem", WK);
    $readmemh("data/wv.mem", WV);

    $dumpfile("attention.vcd");
    $dumpvars(0, attention_top);

    // Compute Q = X * WQ
    for (i = 0; i < 2; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            sum = 0;
            for (k = 0; k < 4; k = k + 1)
                sum = sum + X[i*4+k] * WQ[k*4+j];
            Q[i*4+j] = sum;
        end
    end

    // Compute K = X * WK
    for (i = 0; i < 2; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            sum = 0;
            for (k = 0; k < 4; k = k + 1)
                sum = sum + X[i*4+k] * WK[k*4+j];
            K[i*4+j] = sum;
        end
    end

    // Compute V = X * WV
    for (i = 0; i < 2; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            sum = 0;
            for (k = 0; k < 4; k = k + 1)
                sum = sum + X[i*4+k] * WV[k*4+j];
            V[i*4+j] = sum;
        end
    end

    // Score = Q * K^T
    for (i = 0; i < 2; i = i + 1) begin
        for (j = 0; j < 2; j = j + 1) begin
            sum = 0;
            for (k = 0; k < 4; k = k + 1)
                sum = sum + Q[i*4+k] * K[j*4+k];
            score[i*2+j] = sum;
        end
    end

    // Scaling: divide by sqrt(4)=2
    for (i = 0; i < 4; i = i + 1)
        scaled[i] = score[i] / 2;

    // Simple softmax approximation
    for (i = 0; i < 2; i = i + 1) begin
        if (scaled[i*2] >= scaled[i*2+1]) begin
            attn[i*2]   = 3;
            attn[i*2+1] = 1;
        end else begin
            attn[i*2]   = 1;
            attn[i*2+1] = 3;
        end
    end

    // Output = Attention * V
    for (i = 0; i < 2; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            O[i*4+j] = (attn[i*2] * V[j] + attn[i*2+1] * V[4+j]) / 4;
        end
    end

    f = $fopen("output.txt", "w");
    for (i = 0; i < 8; i = i + 1)
        $fwrite(f, "%0d\n", O[i]);
    $fclose(f);

    $display("Attention output written to output.txt");
    $finish;
end

endmodule
