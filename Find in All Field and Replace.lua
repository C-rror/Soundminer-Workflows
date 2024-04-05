-- Find & replace a pattern across all accessible fields.
-- Written by Theo Serror (April 2024).

-- /!\/!\/!\ CAUTION /!\/!\/!\
-- This workflow is VERY dumb.
-- It WILL rip through all your fields, even ones you don't expect (like BWF & iXML stuff).
-- It only skips over FilePath & Pathname, for obvious reasons.


local function setup(prefs)

  return function (metadata)
      local changedMetadata={}
      local savedFilePath=metadata[FilePath]
      local savedPathname=metadata[Pathname]
      	local caseSensitive=prefs.casesensitive
          if prefs.regex then
          	for kField,vString in pairs(metadata) do
              if kField~='Pathname' and kField~='FilePath' then
                changedMetadata[kField]=smregex.replace(metadata[kField] or '',prefs.find,prefs.replace,caseSensitive)
              end
            end
          else
          	for kField,vString in pairs(metadata) do
              if kField~='Pathname' and kField~='FilePath' then
                changedMetadata[kField]=strutil.replace(metadata[kField] or '',prefs.find,prefs.replace,not caseSensitive)
              end
          	end
          end

--        changedMetadata[Pathname]=savedPathname
--        changedMetadata[FilePath]=savedFilePath

      return changedMetadata
  end
end

function buildUI()
  

    local builder=smbuilder()
    local c=builder:createView('{"text":"FIND IN ALL FIELDS & REPLACE","bounds" : "0,0,parent.width,130"}')
    assert(c,"unable to create view object")

      -- setup flex box
    local flexBox=Flexbox.newBox()
    flexBox.direction=Flexbox.Direction.Column

    local firstRow=flexBox:addChild({height=25,['margin-top']=10})
    firstRow.direction=Flexbox.Direction.Row
   
    local secondRow=flexBox:addChild({height=25,['margin-top']=10})
    secondRow.direction=Flexbox.Direction.Row
    

    local findLabel=builder:create('label','{"text":"Find:", "align" : "right"}'):addToFlexbox(firstRow)
    findLabel.width=80
 
    local findEdit=builder:create('edit','{"id" : "find", "text":""}'):addToFlexbox(firstRow)
    findEdit.flex=1
    findEdit.marginright=10
--[[    local inLabel=builder:create('label','{"text":"in", "align" : "center"}'):addToFlexbox(firstRow)
    inLabel.width=30
    local fieldCombo=builder:create('combo','{"id" : "field", "options" : "stringFields", "text":"Description"}'):addToFlexbox(firstRow)
    fieldCombo.width=150
    fieldCombo.marginright=10
]]--
    local replaceLabel=builder:create('label','{"text":"Replace:", "align" : "center"}'):addToFlexbox(secondRow)
    replaceLabel.width=80

    local replaceEdit=builder:create('edit','{"id" : "replace",  "bounds":"85,77,200,102","text":""}'):addToFlexbox(secondRow)
    replaceEdit.flex=1

    local regexToggle=builder:create('toggle','{"id" : "regex", "text":"RegEx", "state" : 0}'):addToFlexbox(secondRow)
    regexToggle.width=80

    local caseToggle=builder:create('toggle','{"id" : "casesensitive", "text":"Case Sensitive", "state" : 0}'):addToFlexbox(secondRow)
    caseToggle.width=150

    builder:register(c,setup)
    builder:registerFlexbox(c,flexBox)
    -- Now inject this
    return c
 
end
--[[ ========================================================== ]]--
return buildUI

