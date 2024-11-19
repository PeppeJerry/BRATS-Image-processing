function name = normalizeName(num)
    if num < 100
        if num < 10
            num = "00"+num;
        else
            num = "0"+num;
        end
    end
    name="BRATS_"+num+".nii";
end