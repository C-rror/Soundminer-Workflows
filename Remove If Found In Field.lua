-- Delete word in a (target) field when they're already present in another (source) field. 
-- Written by Theo Serror (Nov. 2023)

-- This workflow doesn't do any sanitization of the source/target fields, one might end up with stray whitespaces or separation characters.
-- I didn't heavily test it... Use at one's own risk...

local function setup(prefs)
  
  return function (metadata)
    
    -- Field (typ Filename) that contains the words we want to remove elsewhere. 
  	local sourceField=metadata[prefs.fieldSource]
  	local stringSplitter=smstringarray(sourceField,prefs.splitfield) -- Splits into an array we can iterate over.
    stringSplitter:trim()
    stringSplitter:removeEmptyStrings()

    local stringArray=stringSplitter:getTable()

    -- Field to be stripped strip, typically description.
    local targetField=metadata[prefs.fieldTarget] or ''
    local changedMetadata={}

    for i=1, #stringArray do
	    targetField=smregex.replace(targetField,stringArray[i],'')
	end

    changedMetadata[prefs.fieldTarget]=targetField
    return changedMetadata
    
  end
end

function buildUI()
   
    local builder=smbuilder()
    local c=builder:createView('{"text":"REMOVE IF FOUND IN FIELD","bounds" : "0,0,parent.width,120"}')
    assert(c,"unable to create view object")

    assert(builder:create('label','{"id" : "sourceLabel",  "bounds":"10,42,140,67","text":"Take words from field" ,"align" : "centre"}'))
    assert(builder:create('combo','{"id" : "fieldSource",  "options" : "stringFields",  "bounds":"150,42,250,67","text":"Filename"}'))

    assert(builder:create('label','{"id" : "splitLabel",  "bounds":"255,42,360,67","text":"splitting on" ,"align" : "centre"}'))
    assert(builder:create('edit','{"id" : "splitfield",  "bounds":"365,42,400,67","text":"_"}'))

    assert(builder:create('label','{"id" : "targetLabel",  "bounds":"10,72,140,97","text":"And remove them in" ,"align" : "centre"}'))
    assert(builder:create('combo','{"id" : "fieldTarget",  "options" : "stringFields",  "bounds":"150,72,250,97","text":"Description"}'))



--[[
    assert(builder:create('edit','{"id" : "count",   "bounds":"75,42,100,67","text":"2"}'))
    assert(builder:create('label','{"id" : "fromlabel",  "bounds":"105,42,200,67","text":"Words from" ,"align" : "centre"}'))
    assert(builder:create('combo',{["id"] = "action",  ["options"] = removeOptions,  ["bounds"]="210,42,290,67",["text"]=removeOptions[1]}))
    assert(builder:create('label','{"id" : "oflabel",  "bounds":"295,42,320,67","text":"of" ,"align" : "centre"}'))
    assert(builder:create('combo','{"id" : "destfield",  "options" : "stringFields",  "bounds":"330,42,490,67","text":"Category"}'))
]]--
    builder:register(c,setup)
    -- Now inject this
    return c
 
end
--[[ ========================================================== ]]--
return buildUI

