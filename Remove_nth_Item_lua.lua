
local function setup(prefs)

  return function (metadata)
    
       local changedMetadata={}
        local stringSplitter=smstringarray(metadata[prefs.field] or '',prefs.splitchar)
         stringSplitter:trim() -- trim any whitespace
       
   
        local itemTable=stringSplitter:getTable()
        local count=tonumber(prefs.count)
        local v=stringSplitter:getTable()

          if count<= #v  then
             table.remove(v,count)
             v=table.concat( v, prefs.splitchar)
             changedMetadata[prefs.destfield]=v
           else
            changedMetadata[prefs.destfield]=''
         end
         
        return changedMetadata
  end
end

function buildUI()
   
    local builder=smbuilder()
    local v=builder:createView('{"text":"REMOVE N-th ITEM","bounds" : "0,0,parent.width,120"}')
    assert(v,"unable to create view object")
    local c=nil
    
    
    c=builder:create('label','{  "bounds":"20,42,100,67","text":"Separate", "align" : "right"}')
      assert(c) -- will be a table with a userdata
   
     assert(builder:create('combo','{"id" : "field",  "options" : "stringFields",  "bounds":"110,42,250,67","text":"Description"}'))
  assert(builder:create('label','{"id" : "from",  "bounds":"255,42,430,67","text":"into an array by using" ,"align" : "centre"}'))

     --assert(builder:create('label','{"id" : "split",  "bounds":"20,72,90,97",  "align" : "right","text":"Split on"}'))
       assert(builder:create('edit','{"id" : "splitchar",  "bounds":"435,42,455,67","text":"_"}'))
         assert(builder:create('label','{"id" : "from",  "bounds":"460,42,600,67","text":"to separate"}'))
  
     

    
    assert(builder:create('label','{"id" : "from",  "bounds":"20,72,100,97","text":"Remove the","align" : "right"}'))
  assert(builder:create('edit','{"id" : "count",  "bounds":"105,72,125,97","text":"2"}'))
  
    
      
     assert(builder:create('label','{"id" : "pastelabel",  "bounds":"130,72,240,97","text":"item and put into" ,"align" : "centre"}'))
    
    assert(c) -- will be a table with a userdata
    assert(builder:create('combo','{"id" : "destfield",  "options" : "stringFields",  "bounds":"245,72,350,97","text":"FXName"}'))
    
    
    --assert(c) -- will be a table with a userdata
    builder:register(v,setup)
    -- Now inject this
    return v
 
end
--[[ ========================================================== ]]--
return buildUI

