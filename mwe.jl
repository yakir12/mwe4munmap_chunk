using VideoIO, CameraCalibrations

function time2calib(video, intrinsic_start, intrinsic_stop, extrinsic, checker)
  mktempdir() do path
    intrinsic = extract(video, intrinsic_start, intrinsic_stop, path)
    extrinsic = extract(video, extrinsic, path)
    buildcalibration(checker, extrinsic, intrinsic)
  end
end

function extract(video, ss, t2, path)
  t = t2 - ss
  r = 25/t
  files = joinpath(path, "intrinsic%03d.png")
  VideoIO.FFMPEG.ffmpeg_exe(`-loglevel 8 -ss $ss -i $video -t $t -r $r -vf format=gray,yadif=1,scale=sar"*"iw:ih -pix_fmt gray $files`)
  readdir(path, join = true)
end

function extract(video, ss, path)
  to = joinpath(path, "extrinsic.png")
  VideoIO.FFMPEG.ffmpeg_exe(`-loglevel 8 -ss $ss -i $video -vf format=gray,yadif=1,scale=sar"*"iw:ih -pix_fmt gray -vframes 1 $to`)
  to
end

file = download("https://s3.eu-central-1.amazonaws.com/vision-group-file-sharing/Dungbeetle_temp/mwe.MTS")

x = time2calib(file, 20.506, 39.589, 16.274, 4.1);
