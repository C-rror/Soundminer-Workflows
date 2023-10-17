-- Number records before/after a given pattern
-- Based on Justin Drury's "Find And Replace.lua" and "Number.lua"
-- Written by Theo Serror (Oct. 2023)

-- Sampled behaviour : 
--    METAL FOOTSTEPS Slow    ->  METAL FOOTSTEPS 01 Slow
--    METAL FOOTSTEPS Medium  ->  METAL FOOTSTEPS 02 Medium
--    METAL FOOTSTEPS Fast    ->  METAL FOOTSTEPS 03 Fast

local function setup(prefs)
  local startingNumber=tonumber(prefs.number)
  local separationChar=prefs.sepChar
  local fieldFormat='%.2i'
  if prefs.padding=='0' then
    fieldFormat='%.1i'
  elseif prefs.padding=='00' then
    fieldFormat='%.2i'
  elseif prefs.padding=='000' then
    fieldFormat='%.3i'
  elseif prefs.padding=='0000' then
    fieldFormat='%.4i'
  end
  return function (metadata)
      local changedMetadata={}
      local caseSensitive=prefs.casesensitive
      local numberedReplace=''
      if prefs.op=='APPEND' then
        numberedReplace=prefs.replace..prefs.sepChar..string.format(fieldFormat,startingNumber)
      elseif prefs.op=='PREPEND' then
        numberedReplace=string.format(fieldFormat,startingNumber)..prefs.sepChar..prefs.replace
      end

          if prefs.regex then
                changedMetadata[prefs.field]=smregex.replace(metadata[prefs.field] or '',prefs.find,numberedReplace,caseSensitive)
          else
              changedMetadata[prefs.field]=strutil.replace(metadata[prefs.field] or '',prefs.find,numberedReplace,not caseSensitive) 
          end

      startingNumber=startingNumber+1
      return changedMetadata
  end
end

function buildUI()
  

    local builder=smbuilder()
    local c=builder:createView('{"text":"NUMBER AT PATTERN","bounds" : "0,0,parent.width,200"}')
    assert(c,"unable to create view object")

      -- setup flex box
    local flexBox=Flexbox.newBox()
    flexBox.direction=Flexbox.Direction.Column

    local firstRow=flexBox:addChild({height=25,['margin-top']=10})
    firstRow.direction=Flexbox.Direction.Row
   
    local secondRow=flexBox:addChild({height=25,['margin-top']=10})
    secondRow.direction=Flexbox.Direction.Row

    local thirdRow=flexBox:addChild({height=25,['margin-top']=10})
    thirdRow.direction=Flexbox.Direction.Row    
    
    local fourthRow=flexBox:addChild({height=25,['margin-top']=10})
    fourthRow.direction=Flexbox.Direction.Row    

    local findLabel=builder:create('label','{"text":"Find:", "align" : "right"}'):addToFlexbox(firstRow)
    findLabel.width=80
 
    local findEdit=builder:create('edit','{"id" : "find", "text":""}'):addToFlexbox(firstRow)
    findEdit.flex=1
    local inLabel=builder:create('label','{"text":"in", "align" : "center"}'):addToFlexbox(firstRow)
    inLabel.width=30
    local fieldCombo=builder:create('combo','{"id" : "field", "options" : "stringFields", "text":"Description"}'):addToFlexbox(firstRow)
    fieldCombo.width=150
    fieldCombo.marginright=10

    local replaceLabel=builder:create('label','{"text":"Replace:", "align" : "center"}'):addToFlexbox(secondRow)
    replaceLabel.width=80

    local replaceEdit=builder:create('edit','{"id" : "replace",  "bounds":"85,77,200,102","text":""}'):addToFlexbox(secondRow)
    replaceEdit.flex=1

    local regexToggle=builder:create('toggle','{"id" : "regex", "text":"RegEx", "state" : 0}'):addToFlexbox(secondRow)
    regexToggle.width=80

    local caseToggle=builder:create('toggle','{"id" : "casesensitive", "text":"Case Sensitive", "state" : 0}'):addToFlexbox(secondRow)
    caseToggle.width=150

    local startLabel=builder:create('label','{"text":"Start # at:", "align" : "center"}'):addToFlexbox(thirdRow)
    startLabel.width=100

    local startEdit=builder:create('edit', '{"id" : "number", "text":"0"}'):addToFlexbox(thirdRow)
    startEdit.width=80
    startEdit.marginright=20

    local separateLabel=builder:create('label','{"text":"Separate with:", "align" : "center"}'):addToFlexbox(thirdRow)
    separateLabel.width=100

    local separateEdit=builder:create('edit', '{"id" : "sepChar", "text":""}'):addToFlexbox(thirdRow)
    separateEdit.width=80

    local formatLabel=builder:create('label','{"text":"Format:", "align" : "center"}'):addToFlexbox(fourthRow)
    formatLabel.width=80

    local formatCombo=builder:create('combo',{["id"] = "padding",  ["options"] = {'0','00','000','0000'}}):addToFlexbox(fourthRow)
    formatCombo.width=80

    local appendCombo=builder:create('combo',{["id"] = "op",  ["options"] = {'APPEND','PREPEND'}}):addToFlexbox(fourthRow)
    appendCombo.width=80



    builder:register(c,setup)
    builder:registerFlexbox(c,flexBox)
    -- Now inject this
    return c
 
end
--[[ ========================================================== ]]--
return buildUI

