local slide=require("MySlide")

local cur_index--直接定位某一页
local sum_page=10--总页数

local function creat_content( cur_index)
	print("main的creat_content is worked  page:"..cur_index)
	local pageGroup=display.newGroup()--每页的内容组
	local rect=display.newRoundedRect( pageGroup, display.contentCenterX,display.contentCenterY, display.contentWidth-40,display.contentHeight,20 )
	rect:setFillColor(0, 1, 0)
	local num_page=display.newText(pageGroup,"page:"..cur_index.."/"..sum_page,display.contentCenterX,display.contentCenterY,native.systemFontBold,30)
    num_page:setFillColor(1, 0, 0)
	return pageGroup
end 
local options={
	cur_index=5,
	sum_page=sum_page,
	create_content=creat_content
}
local object=slide.new(options)
