module (..., package.seeall)

local sceneW=display.contentWidth
local sceneGroup=display.newGroup()

local function create_contentPage(curIndex)--对调用者的创建内容函数优化，考虑curPage<1等情况
	print("create_contentPage is worked  ".."page:"..curIndex)
	local pageGroup=display.newGroup()
	if curIndex<1 or curIndex>sceneGroup.sumPage then
		return pageGroup
	end
	pageGroup=sceneGroup.createContent(curIndex)
	return pageGroup
end

local function create_moveGroup(curIndex)
	print("create_moveGroup is worked")
	local moveGroup=display.newGroup()
	moveGroup.x=-2*sceneW
	moveGroup.y=0
	moveGroup.curIndex=curIndex
	moveGroup.list={}
	j=0

	for i=curIndex-2, curIndex+2 do
		local pageGroup=create_contentPage(i)
		pageGroup.x=j*sceneW
		j=j+1
		moveGroup:insert(pageGroup)
		moveGroup.pageGroup=pageGroup
		moveGroup.list[#moveGroup.list+1]=pageGroup
	end
	return moveGroup
end

local function move_moveGroup(event)
	print("move_moveGroup is worked moveGroup.name:"..event.target.name)
	local moveGroup=event.target
	local phase=event.phase

    if ( "began" == phase ) then
    	print( "Touch event began on: " .. event.target.name )
        display.currentStage:setFocus( moveGroup )
        moveGroup.isFocus = true
        moveGroup.star_position=moveGroup.x
	    moveGroup.star_delt=event.x-moveGroup.x
    	time_star=system.getTimer()

    elseif ( "moved" == phase ) then
    	print( "Touch event began on: moveGroup.x:" ..moveGroup.x )
    	moveGroup.x = event.x -  moveGroup.star_delt

    elseif ( "ended" == phase or "cancelled" == phase ) then
        local delt=moveGroup.x-moveGroup.star_position
        time_end=system.getTimer()
        local velosity=delt/(time_end-time_star)
        print("velosity"..velosity)
        if (delt>40 or velosity>0.02) and moveGroup.curIndex>1 then
        	print("curIndex:"..moveGroup.curIndex)
    		moveGroup.move_right(moveGroup,delt)

    	elseif (delt<-40 or velosity<-0.02) and  moveGroup.curIndex<sceneGroup.sumPage then
    		print("delt:"..delt.."velosity:"..velosity)
    		moveGroup.move_left(moveGroup,delt)
    	else
    		moveGroup.x=moveGroup.star_position
    	end
        display.currentStage:setFocus( nil )
        moveGroup.isFocus = false
    end
    return true 
end

local function move_right( moveGroup,delt )
	transition.to(moveGroup, {time = 300, x=moveGroup.x-delt+sceneW})
	display.remove(moveGroup.list[5])
	moveGroup.list[5]=nil
	table.remove(moveGroup.list,5)
    local pageGroup=create_contentPage(moveGroup.curIndex-3)
	moveGroup:insert(pageGroup)
	table.insert(moveGroup.list,1,pageGroup)
	moveGroup.list[1]=pageGroup
	moveGroup.list[1].x=moveGroup.list[2].x-sceneW
	moveGroup.curIndex=moveGroup.curIndex-1
end

local function move_left( moveGroup,delt )
	transition.to(moveGroup, {time = 300, x=moveGroup.x-delt-sceneW})
	display.remove(moveGroup.list[1])
	moveGroup.list[1]=nil
	table.remove(moveGroup.list,1)
    local pageGroup=create_contentPage(moveGroup.curIndex+3)
	moveGroup:insert(pageGroup)
	table.insert(moveGroup.list,5,pageGroup)
	moveGroup.list[5]=pageGroup
	moveGroup.list[5].x=moveGroup.list[4].x+sceneW
	moveGroup.curIndex=moveGroup.curIndex+1
end

function new( options )
	print("new is worked") 
	local curIndex=options.cur_index
	local sumPage=options.sum_page

	sceneGroup.curIndex=options.cur_index
	sceneGroup.sumPage=options.sum_page
	sceneGroup.createContent=options.create_content
    local moveGroup=create_moveGroup(curIndex)
    moveGroup.name="moveGroup"
    moveGroup.sumPage=sumPage
    sceneGroup:insert(moveGroup)
    moveGroup:addEventListener( "touch", move_moveGroup)
    moveGroup.move_right=move_right
    moveGroup.move_left=move_left
	return sceneGroup
end