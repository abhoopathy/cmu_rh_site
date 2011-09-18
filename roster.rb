def csv_to_hash(csv)
  lineArray = []
  File.open(csv, 'r').each do |line|
    lineArray.push((line.gsub(/\n/,'')).split(','))
  end
  resultHash = []
  headerList = lineArray[0]
  for i in (1...lineArray.length) do
    player = Hash.new
    for j in (0...headerList.length) do
      player[headerList[j].strip] = lineArray[i][j]
    end
    resultHash[i-1] = player
  end
  resultHash
end

p csv_to_hash('schedule.csv')
