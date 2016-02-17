%read the brick data and verify its correction?

fid=fopen('D:\\lwtworker\\DHII1\\new\\DHII\\src\\DigitalAnatomySystem\\brickdata.txt');
width=fscanf(fid,'%d',1);
height=fscanf(fid,'%d',1);
depth=fscanf(fid,'%d',1);


A=zeros(width,height,depth);
for dep=1:depth
    for h=1:height
        for w=1:width
            A(w,h,dep)=fscanf(fid,'%d',1);
        end
    end
end

A=255-A;

imm=A(:,:,7);


fclose(fid);