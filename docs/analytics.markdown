# Sense-checking our analytics email against Google Analytics

## 1. Choose your pod

Tasha's pod (id = 26)
Pod admin (id = 32)

## 2. Get references to everything

pod = Pod.where(id: 26)[0]
pa = PodAdmin.where(id: 32)[0]
parents = pod.parents
slugs = []

parents.each do |parent|
  slugs.append(parent.slug)
end

p pod
p pa
p parents
p slugs

## 3. Open GA

- Set the correct 7 day period (day before today, 7 days back)
- Go to 'Behaviour > Site Content'

## 4. Search for parent slugs

Search for each parent slug and see which games they visited by looking at the URL

    _a91XEQ visited 29, 13, 17, 20
    tPSvaak visited 29, 20
    ohqM3ro didn't visit 
    uJ-2vXY didn't visit  
    Co9vn8k didn't visit
    tXP-ohk didn't visit

## 5. Which game is that?

Game.where(id: 29)[0].name
