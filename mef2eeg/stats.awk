{
    if (min == "") { min = max = $1 };
    if ($1 > max)  { max = $1 };
    if ($1 < min)  { min = $1 };

    # compute standard deviation using a running statistics method
    sum += $1;
    sumsq += $1*$1;
}

END {
    mean = (sum / NR);
    std = sqrt(sumsq / NR - mean**2);

    printf "number_of_eztrack_samples = %s\n", NR;
    printf "max = %f\n", max;
    printf "min = %f\n", min;
    printf "range = %f\n", (max-min);
    printf "mean = %f\n", mean;
    printf "std = %f\n", std;
    printf "snr = %f\n", (mean/std); # snr: signal-to-noise ratio
}
