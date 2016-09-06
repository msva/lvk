local LuaVkApi = {}
local LuaVkApi_mt = {
  __metatable = {},
  __index = LuaVkApi
}

local https = require("ssl.https")
local json = require ("dkjson")

local apiRequest = "https://api.vk.com/method/{METHOD_NAME}" .. "?{PARAMETERS}"
  .. "&access_token={ACCESS_TOKEN}" .. "&v={API_VERSION}"

 
function LuaVkApi:new(token, apiVersion)
    if self ~= LuaVkApi then
        return nil, "First argument must be self"
    end
 
    local o = setmetatable({}, LuaVkApi_mt)
    o._token = token
	o._apiVersion = apiVersion
    return o
end

setmetatable(LuaVkApi, {
  __call = LuaVkApi.new
})

-----------------------
--Common util methods--
-----------------------
function LuaVkApi:invokeApi(method, params)
  -- parse method parameters
  local parameters = ""
  if params ~= nil then
    for key, value in pairs(params) do
      parameters = parameters .. key .. "=" .. value .. "&"
    end
  end

  local reqUrl = string.gsub(apiRequest, "{METHOD_NAME}", method)
  reqUrl = string.gsub(reqUrl, "{ACCESS_TOKEN}", self._token)
  reqUrl = string.gsub(reqUrl, "{API_VERSION}", self._apiVersion)
  reqUrl = string.gsub(reqUrl, "{PARAMETERS}&", parameters)
  return https.request(reqUrl)
end

function LuaVkApi:stringToJson(jsonString_)
  local jsonString = jsonString_
  return json.decode(jsonString, 1, nil)
end

function LuaVkApi:jsonToString(jsonObject_)
  local jsonObject = jsonObject_
  return json.encode(jsonObject)
end

-----------------------
--      Users        --
-----------------------
function LuaVkApi:getUsersInfo(userIds, returnedFields, nameCase)
  return self:invokeApi("users.get", {user_ids=userIds, fields=returnedFields,
      name_case=nameCase})
end

function LuaVkApi:searchUsers(queryString, sortVal, offsetVal, countVal, returnedFields,
    cityVal, countryVal, hometownVal, universityCountry, universityVal, universityYear,
    universityFaculty, universityChair, sexVal, statusVal, ageFrom, ageTo, birthDay,
    birthMonth, birthYear, isOnline, hasPhoto, schoolCountry, schoolCity, schoolClass,
    schoolVal, schoolYear, religionVal, interestsVal, companyVal, positionVal, groupId,
    fromList)
  return self:invokeApi("users.search", {q=queryString, sort=sortVal, offset=offsetVal,
      count=countVal, fields=returnedFields, city=cityVal, country=countryVal, 
      hometown=hometownVal, university_country=universityCountry, university=universityVal,
      university_year=universityYear, university_faculty=universityFaculty, 
      university_chair=universityChair, sex=sexVal, status=statusVal, age_from=ageFrom,
      age_to=ageTo, birth_day=birthDay, birth_month=birthMonth, birth_year=birthYear,
      online=isOnline, has_photo=hasPhoto, school_country=schoolCountry,
      school_city=schoolCity, school_class=schoolClass, school=schoolVal, 
      school_year=schoolYear, religion=religionVal, interests=interestsVal,
      company=companyVal, position=positionVal, group_id=groupId, from_list=fromList})
end

function LuaVkApi:isAppUser(userId)
  return self:invokeApi("users.isAppUser", {user_id=userId})
end

function LuaVkApi:getSubscriptions(userId, extendedVal, offsetVal, countVal, fieldsVal)
  return self:invokeApi("users.getSubscriptions", {user_id=userId, extended=extendedVal,
      offset=offsetVal, count=countVal, fields=fieldsVal})
end

function LuaVkApi:getFollowers(userId, nameCase, offsetVal, countVal, fieldsVal)
  return self:invokeApi("users.getFollowers", {user_id=userId, name_case=nameCase,
      offset=offsetVal, count=countVal, fields=fieldsVal})
end

function LuaVkApi:reportUser(userId, typeVal, commentVal)
  return self:invokeApi("users.report", {user_id=userId, type=typeVal, comment=commentVal})
end

function LuaVkApi:getNearbyUsers(latitudeVal, longitudeVal, accuracyVal, timeoutVal, radiusVal,
    fieldsVal, nameCase)
  return self:invokeApi("users.getNearby", {latitude=latitudeVal, longitude=longitudeVal,
      accuracy=accuracyVal, timeout=timeoutVal, radius=radiusVal, fields=fieldsVal,
      name_case=nameCase})
end

-----------------------
--  Authorization    --
-----------------------
function LuaVkApi:checkPhone(phoneNumber, userId, clientSecret)
  return self:invokeApi("auth.checkPhone", {phone=phoneNumber, client_id=userId,
      client_secret=clientSecret})
end

function LuaVkApi:signup(firstName, lastName, clientId, clientSecret, phoneVal,
    passwordVal, testMode, voiceVal, sexVal, sidVal)
  return self:invokeApi("auth.signup", {first_name=firstName, last_name=lastName,
      client_id=clientId, client_secret=clientSecret, phone=phoneVal, password=passwordVal,
      test_mode=testMode, voice=voiceVal, sex=sexVal, sid=sidVal})
end

function LuaVkApi:confirm(userId, clientSecret, phoneNumber, codeVal, passwordVal,
    testMode, introVal)
  return self:invokeApi("auth.confirm", {client_id=userId, client_secret=clientSecret,
      phone=phoneNumber, code=codeVal, password=passwordVal, test_mode=testMode,
      intro=introVal})
end

function LuaVkApi:restore(phoneNumber)
  return self:invokeApi("auth.restore", {phone=phoneNumber})
end

-----------------------
--       Wall        --
-----------------------
function LuaVkApi:getWallPosts(ownerId, domainVal, offsetVal, countVal, filterVal,
    isExtended, fieldsVal)
  return self:invokeApi("wall.get", {owner_id=ownerId, domain=domainVal,
      offset=offsetVal, count=countVal, filter=filterVal, extended=isExtended,
      fields=fieldsVal})
end

function LuaVkApi:searchWallPosts(ownerId, domainVal, queryStr, offsetVal, countVal,
    ownersOnly, filterVal, isExtended, fieldsVal)
  return self:invokeApi("wall.search", {owner_id=ownerId, domain=domainVal,
      query=queryStr, offset=offsetVal, count=countVal, owners_only=ownersOnly,
      filter=filterVal, extended=isExtended, fields=fieldsVal})
end

function LuaVkApi:getWallById(postIds, isExtended, copyHistoryDepth, fieldsVal)
  return self:invokeApi("wall.getById", {posts=postIds, extended=isExtended,
      copy_history_depth=copyHistoryDepth, fields=fieldsVal})
end

function LuaVkApi:post(ownerId, friendsOnly, fromGroup, messageVal, postAttachments,
    servicesList, isSigned, publishDate, latitude, longitude, placeId, postId)
  return self:invokeApi("wall.post", {owner_id=ownerId, friends_only=friendsOnly,
      from_group=fromGroup, message=messageVal, attachments=postAttachments,
      services=servicesList, signed=isSigned, publish_date=publishDate, lat=latitude,
      long=longitude, place_id=placeId, post_id=postId})
end

function LuaVkApi:doRepost(objectId, messageStr, groupId, refVal)
  return self:invokeApi("wall.repost", {object=objectId, message=messageStr,
      group_id=groupId, ref=refVal})
end

function LuaVkApi:getReposts(ownerId, postId, offsetVal, countVal)
  return self:invokeApi("wall.getReposts", {owner_id=ownerId, post_id=postId,
      offset=offsetVal, count=countVal})
end

function LuaVkApi:editPost(ownerId, postId, friendsOnly, messageVal, postAttachments,
    servicesList, isSigned, publishDate, latitude, longitude, placeId)
  return self:invokeApi("wall.edit", {owner_id=ownerId, post_id=postId, 
      friends_only=friendsOnly, message=messageVal, attachments=postAttachments,
      services=servicesList, signed=isSigned, publish_date=publishDate, lat=latitude,
      long=longitude, place_id=placeId})
end

function LuaVkApi:deletePost(ownerId, postId)
  return self:invokeApi("wall.delete", {owner_id=ownerId, post_id=postId})
end

function LuaVkApi:restorePost(ownerId, postId)
  return self:invokeApi("wall.restore", {owner_id=ownerId, post_id=postId})
end

function LuaVkApi:pinPost(ownerId, postId)
  return self:invokeApi("wall.pin", {owner_id=ownerId, post_id=postId})
end

function LuaVkApi:unpinPost(ownerId, postId)
  return self:invokeApi("wall.unpin", {owner_id=ownerId, post_id=postId})
end

function LuaVkApi:getComments(ownerId, postId, needLikes, startCommentId, offsetVal,
    countVal, sortVal, previewLength, isExtened)
  return self:invokeApi("wall.getComments", {owner_id=ownerId, post_id=postId, 
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal,
      count=countVal, sort=sortVal, preview_length=previewLength, extended=isExtened})
end

function LuaVkApi:addComment(ownerId, postId, fromGroup, textVal, replyToComment,
    commentAttachments, stickerId, refVal)
  return self:invokeApi("wall.addComment", {owner_id=ownerId, post_id=postId, 
      from_group=fromGroup, text=textVal, reply_to_comment=replyToComment,
      attachments=commentAttachments, sticker_id=stickerId, ref=refVal})
end

function LuaVkApi:editComment(ownerId, commentId, messageVal, replyToComment, commentAttachments)
  return self:invokeApi("wall.editComment", {owner_id=ownerId, comment_id=commentId, 
      message=messageVal, reply_to_comment=replyToComment, attachments=commentAttachments})
end

function LuaVkApi:deleteComment(ownerId, commentId)
  return self:invokeApi("wall.deleteComment", {owner_id=ownerId, comment_id=commentId})
end

function LuaVkApi:restoreComment(ownerId, commentId)
  return self:invokeApi("wall.restoreComment", {owner_id=ownerId, comment_id=commentId})
end

function LuaVkApi:reportPost(ownerId, postId, reasonVal)
  return self:invokeApi("wall.reportPost", {owner_id=ownerId, post_id=postId,
      reason=reasonVal})
end

function LuaVkApi:reportComment(ownerId, commentId, reasonVal)
  return self:invokeApi("wall.reportComment", {owner_id=ownerId, comment_id=commentId,
      reason=reasonVal})
end

-----------------------
--     Photos        --
-----------------------
function LuaVkApi:createPhotoAlbum(titleVal, groupId, descriptionVal, privacyView,
    privacyComment, uploadByAdminsOnly, commentsDissabled)
  return self:invokeApi("photos.createAlbum", {title=titleVal, grop_id=groupId,
      description=descriptionVal, privacy_view=privacyView, privacy_comment=privacyComment,
      upload_by_admins_only=uploadByAdminsOnly, comments_dissabled=commentsDissabled})
end

function LuaVkApi:editPhotoAlbum(albumId, titleVal, descriptionVal, ownerId, privacyView,
    privacyComment, uploadByAdminsOnly, commentsDissabled)
  return self:invokeApi("photos.editAlbum", {album_id=albumId, title=titleVal,
      description=descriptionVal, owner_id=ownerId, privacy_view=privacyView, 
      privacy_comment=privacyComment, upload_by_admins_only=uploadByAdminsOnly, 
      comments_dissabled=commentsDissabled})
end

function LuaVkApi:getPhotoAlbums(ownerId, albumIds, offsetVal, countVal, needSystem,
    needCovers, photoSizes)
  return self:invokeApi("photos.getAlbums", {owner_id=ownerId, album_ids=albumIds,
      offset=offsetVal, count=countVal, need_system=needSystem, need_covers=needCovers,
      photo_sizes=photoSizes})
end

function LuaVkApi:getPhotos(ownerId, albumId, photoIds, revVal, isExtended, feedType,
    feedVal, photoSizes, offsetVal, countVal)
  return self:invokeApi("photos.get", {owner_id=ownerId, album_id=albumId,
      photo_ids=photoIds, rev=revVal, extended=isExtended, feed_type=feedType,
      feed=feedVal, photo_sizes=photoSizes, offset=offsetVal, count=countVal})
end

function LuaVkApi:getPhotoAlbumsCount(userId, groupId)
  return self:invokeApi("photos.getAlbumsCount", {user_id=userId, group_id=groupId})
end

function LuaVkApi:getPhotosById(photosVal, isExtended, photoSizes)
  return self:invokeApi("photos.getById", {photos=photosVal, extended=isExtended,
      photo_sizes=photoSizes})
end

function LuaVkApi:getPhotoUploadServer(albumId, groupId)
  return self:invokeApi("photos.getUploadServer", {album_id=albumId, group_id=groupId})
end

function LuaVkApi:getOwnerPhotoUploadServer(ownerId)
  return self:invokeApi("photos.getOwnerPhotoUploadServer", {owner_id=ownerId})
end

function LuaVkApi:getChatCoverUploadServer(chatId, cropX, cropY, cropWidth)
  return self:invokeApi("photos.getChatUploadServer", {chat_id=chatId, crop_x=cropX,
      crop_y=cropY, crop_width=cropWidth})
end

function LuaVkApi:saveOwnerPhoto(serverVal, hashVal, photoVal)
  return self:invokeApi("photos.saveOwnerPhoto", {server=serverVal, hash=hashVal,
      photo=photoVal})
end 

function LuaVkApi:saveWallPhoto(userId, groupId, photoVal, serverVal, hashVal)
  return self:invokeApi("photos.saveWallPhoto", {user_id=userId, group_id=groupId,
      photo=photoVal, server=serverVal, hash=hashVal})
end

function LuaVkApi:getWallPhotoUploadServer(groupId)
  return self:invokeApi("photos.getWallUploadServer", {group_id=groupId})
end

function LuaVkApi:getMessagesUploadServer()
  return self:invokeApi("photos.getMessagesUploadServer")
end

function LuaVkApi:saveMessagesPhoto(photoVal)
  return self:invokeApi("photos.saveMessagesPhoto", {photo=photoVal})
end

function LuaVkApi:reportPhoto(ownerId, photoId, reasonVal)
  return self:invokeApi("photos.report", {owner_id=ownerId, photo_id=photoId,
      reason=reasonVal})
end

function LuaVkApi:reportPhotoComment(ownerId, commentId, reasonVal)
  return self:invokeApi("photos.reportComment", {owner_id=ownerId, comment_id=commentId,
      reason=reasonVal})
end

function LuaVkApi:searchPhotos(query, latitude, longitude, startTime, endTime, sortVal,
    offsetVal, countVal, radiusVal)
  return self:invokeApi("photos.search", {q=query, lat=latitude, long=longitude,
      start_time=startTime, end_time=endTime, sort=sortVal, offset=offsetVal,
      count=countVal, radius=radiusVal})
end

function LuaVkApi:savePhoto(albumId, groupId, serverVal, photosList, hashVal,
    latitudeVal, longitudeVal, captionVal)
  return self:invokeApi("photos.save", {album_id=albumId, group_id=groupId,
  server=serverVal, photos_list=photosList, hash=hashVal, latitude=latitudeVal,
  longitude=longitudeVal, caption=captionVal})
end

function LuaVkApi:copyPhoto(ownerId, photoId, accessKey)
  return self:invokeApi("photos.copy", {owner_id=ownerId, photo_id=photoId, 
      access_key=accessKey})
end

function LuaVkApi:editPhoto(ownerId, photoId, captionVal, latitudeVal, longitudeVal,
    placeStr, foursquareId, deletePlace)
  return self:invokeApi("photos.edit", {owner_id=ownerId, photo_id=photoId,
      caption=captionVal, latitude=latitudeVal, longitude=longitudeVal,
      place_str=placeStr, foursquare_id=foursquareId, delete_place=deletePlace})
end

function LuaVkApi:movePhoto(ownerId, targetAlbumId, photoId)
  return self:invokeApi("photos.move", {owner_id=ownerId, target_album_id=targetAlbumId,
      photo_id=photoId})
end

function LuaVkApi:makeCover(ownerId, photoId, albumId)
  return self:invokeApi("photos.makeCover", {owner_id=ownerId, photo_id=photoId,
      album_id=albumId})
end

function LuaVkApi:reorderPhotoAlbums(ownerId, albumId, beforeVal, afterVal)
  return self:invokeApi("photos.reorderAlbums", {owner_id=ownerId, album_id=albumId,
      before=beforeVal, after=afterVal})
end

function LuaVkApi:reorderPhotos(ownerId, photoId, beforeVal, afterVal)
  return self:invokeApi("photos.reorderPhotos", {owner_id=ownerId, photo_id=photoId,
      before=beforeVal, after=afterVal})
end

function LuaVkApi:getAllPhotos(ownerId, isExtended, offsetVal, countVal, photoSizes,
    noServiceAlbums, needHidden, skipHidden)
  return self:invokeApi("photos.getAll", {owner_id=ownerId, extended=isExtended,
      offset=offsetVal, count=countVal, photo_sizes=photoSizes, no_service_albums=noServiceAlbums,
      need_hidden=needHidden, skip_hidden=skipHidden})
end

function LuaVkApi:getUserPhotos(userId, offsetVal, countVal, isExtended, sortVal)
  return self:invokeApi("photos.getUserPhotos", {user_id=userId, offset=offsetVal,
      count=countVal, extended=isExtended, sort=sortVal})
end

function LuaVkApi:deletePhotoAlbum(albumId, groupId)
  return self:invokeApi("photos.deleteAlbum", {album_id=albumId, group_id=groupId})
end

function LuaVkApi:deletePhoto(ownerId, photoId)
  return self:invokeApi("photos.delete", {owner_id=ownerId, photo_id=photoId})
end

function LuaVkApi:restorePhoto(ownerId, photoId)
  return self:invokeApi("photos.restore", {owner_id=ownerId, photo_id=photoId})
end

function LuaVkApi:confirmPhotoTag(ownerId, photoId, tagId)
  return self:invokeApi("photos.confirmTag", {owner_id=ownerId, photo_id=photoId,
      tag_id=tagId})
end

function LuaVkApi:getNewPhotoTags(offsetVal, countVal)
  return self:invokeApi("photos.getNewTags", {offset=offsetVal, count=countVal})
end

function LuaVkApi:removePhotoTag(ownerId, photoId, tagId)
  return self:invokeApi("photos.removeTag", {owner_id=ownerId, photo_id=photoId,
      tag_id=tagId})
end

function LuaVkApi:putPhotoTag(ownerId, photoId, userId, x_, y_, x2_, y2_)
  return self:invokeApi("photos.putTag", {owner_id=ownerId, photo_id=photoId,
      user_id=userId, x=x_, y=y_, x2=x2_, y2=y2_})
end

function LuaVkApi:gePhotoTags(ownerId, photoId, accessKey)
  return self:invokeApi("photos.getTags", {owner_id=ownerId, photo_id=photoId,
      access_key=accessKey})
end

function LuaVkApi:gePhotoComments(ownerId, photoId, needLikes, startCommentId, offsetVal,
    countVal, sortVal, accessKey, isExtended, fieldsVal)
  return self:invokeApi("photos.getComments", {owner_id=ownerId, photo_id=photoId,
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal,
      count=countVal, sort=sortVal, access_key=accessKey, extended=isExtended,
      fields=fieldsVal})
end

function LuaVkApi:getAllPhotoComments(ownerId, albumId, needLikes, offsetVal, countVal)
  return self:invokeApi("photos.getAllComments", {owner_id=ownerId, album_id=albumId,
      need_likes=needLikes, offset=offsetVal, count=countVal})
end

function LuaVkApi:createPhotoComment(ownerId, photoId, messageStr, attachmentsVal, fromGroup,
    replyToComment, stickerId, accessKey, guidVal)
  return self:invokeApi("photos.createComment", {owner_id=ownerId, photo_id=photoId,
      message=messageStr, attachments=attachmentsVal, from_group=fromGroup,
      reply_to_comment=replyToComment, sticker_id=stickerId, access_key=accessKey,
      guid=guidVal})
end

function LuaVkApi:deletePhotoComment(ownerId, commentId)
  return self:invokeApi("photos.deleteComment", {owner_id=ownerId, comment_id=commentId})
end

function LuaVkApi:restorePhotoComment(ownerId, commentId)
  return self:invokeApi("photos.restoreComment", {owner_id=ownerId, comment_id=commentId})
end

function LuaVkApi:editPhotoComment(ownerId, commentId, messageVal, attachmentsVal)
  return self:invokeApi("photos.editComment", {owner_id=ownerId, comment_id=commentId,
      message=messageVal, attachments=attachmentsVal})
end

function LuaVkApi:saveMarketAlbumPhoto(groupId, photoVal, serverVal, hashVal)
  return self:invokeApi("photos.saveMarketAlbumPhoto", {group_id=groupId, photo=photoVal,
      server=serverVal, hash=hashVal})
end

function LuaVkApi:saveMarketPhoto(groupId, photoVal, serverVal, hashVal, cropData, cropHash)
  return self:invokeApi("photos.saveMarketPhoto", {group_id=groupId, photo=photoVal,
      server=serverVal, hash=hashVal, crop_data=cropData, crop_hash=cropHash})
end

function LuaVkApi:getMarketAlbumUploadServer(groupId)
  return self:invokeApi("photos.getMarketAlbumUploadServer", {group_id=groupId})
end

function LuaVkApi:getMarketUploadServer(groupId, mainPhoto, cropX, cropY, cropWidth)
  return self:invokeApi("photos.getMarketUploadServer", {group_id=groupId, main_photo=mainPhoto,
  	crop_x=cropX, crop_y=cropY, crop_width=cropWidth})
end

-----------------------
--     Friends       --
-----------------------
function LuaVkApi:getFriendIds(userId, orderVal, listId, countVal, offsetVal, 
    fieldsVal, nameCase)
  return self:invokeApi("friends.get", {user_id=userId, order=orderVal, list_id=listId, 
      count=countVal, offset=offsetVal, fields=fieldsVal, name_case=nameCase})
end

function LuaVkApi:addToFriends(userId, textVal, followVal)
  return self:invokeApi("friends.add", {user_id=userId, text=textVal, follow=followVal})
end

function LuaVkApi:getOnlineFriends(userId, listId, onlineMobile, sortOrder, countVal, offsetVal)
  return self:invokeApi("friends.getOnline", {user_id=userId, list_id=listId,
      online_mobile=onlineMobile, order=sortOrder, count=countVal, offset=offsetVal})
end

function LuaVkApi:getMutualFriends(sourceUid, targetUid, targetUids, sortOrder,
    countVal, offsetVal)
  return self:invokeApi("friends.getMutual", {source_uid=sourceUid, target_uid=targetUid,
      target_uids=targetUids, order=sortOrder, count=countVal, offset=offsetVal})
end

function LuaVkApi:getRecentFriends(countVal)
  return self:invokeApi("friends.getRecent", {count=countVal})
end

function LuaVkApi:getFriendsRequests(countVal, offsetVal, extendedVal, needMutual, outVal, sortVal,
    suggestedVal)
  return self:invokeApi("friends.getRequests", {count=countVal, offset=offsetVal, 
      extended=extendedVal, need_mutual=needMutual, out=outVal, sort=sortVal, suggested=suggestedVal})
end

function LuaVkApi:editFriendsList(userId, listIds)
  return self:invokeApi("friends.edit", {user_id=userId, list_ids=listIds})
end

function LuaVkApi:deleteFriend(userId)
  return self:invokeApi("friends.delete", {user_id=userId})
end

function LuaVkApi:getFriendsOfFriendsIds(userId, returnSystem)
  return self:invokeApi("friends.getLists", {user_id=userId, return_system=returnSystem})
end

function LuaVkApi:addFriendList(nameVal, userIds)
  return self:invokeApi("friends.addList", {name=nameVal, user_ids=userIds})
end

function LuaVkApi:editFriendList(nameVal, listId, userIds, addUserIds, deleteUserIds)
  return self:invokeApi("friends.editList", {name=nameVal, list_id=listId, user_ids=userIds,
      add_user_ids=addUserIds, delete_user_ids=deleteUserIds})
end

function LuaVkApi:deleteFriendList(listId)
  return self:invokeApi("friends.deleteList", {list_id=listId})
end

function LuaVkApi:getAppUsers()
  return self:invokeApi("friends.getAppUsers")
end

function LuaVkApi:getUsersByPhones(phonesVal, fieldsVal)
  return self:invokeApi("friends.getByPhones", {phones=phonesVal, fields=fieldsVal})
end

function LuaVkApi:deleteAllFriendsRequests()
  return self:invokeApi("friends.deleteAllRequests")
end

function LuaVkApi:getFriendsSuggestions(filterVal, countVal, offsetVal,fieldsVal, nameCase)
  return self:invokeApi("friends.getSuggestions", {filter=filterVal, count=countVal,
      offset=offsetVal, fields=fieldsVal, name_case=nameCase})
end

function LuaVkApi:areFriends(userIds, needSign)
  return self:invokeApi("friends.areFriends", {user_ids=userIds, need_sign=needSign})
end

function LuaVkApi:getAvailableFriendsForCall(fieldsVal, nameCase)
  return self:invokeApi("friends.getAvailableForCall", {fields=fieldsVal, name_case=nameCase})
end

function LuaVkApi:searchFriends(userId, query, fieldsVal, nameCase, offsetVal, countVal)
  return self:invokeApi("friends.search", {user_id=userId, q=query, fields=fieldsVal,
      name_case=nameCase, offset=offsetVal, count=countVal})
end

-----------------------
--     Widgets       --
-----------------------
function LuaVkApi:getCommentsFromWidget(widgetApiId, urlStr, pageId, orderVal,
    fieldsVal, offsetVal, countVal)
  return self:invokeApi("widgets.getComments", {widget_api_id=widgetApiId, url=urlStr,
      page_id=pageId, order=orderVal, fields=fieldsVal, offset=offsetVal, count=countVal})
end

function LuaVkApi:getPagesWithWidget(widgetApiId, orderVal, periodVal, offsetVal, countVal)
  return self:invokeApi("widgets.getPages", {widget_api_id=widgetApiId, order=orderVal,
      period=periodVal, offset=offsetVal, count=countVal})
end

-----------------------
--    Data storage   --
-----------------------
function LuaVkApi:getStorageVariable(keyStr, keysStr, userId, globalVal)
  return self:invokeApi("storage.get", {key=keyStr, keys=keysStr, user_id=userId,
      global=globalVal})
end

function LuaVkApi:setStorageVariable(keyStr, valueStr, userId, globalVal)
  return self:invokeApi("storage.set", {key=keyStr, value=valueStr, user_id=userId,
      global=globalVal})
end

function LuaVkApi:getVariableKeys(userId, globalVal, offsetVal, countVal)
  return self:invokeApi("storage.getKeys", {user_id=userId, global=globalVal,
      offset=offsetVal, count=countVal})
end

-----------------------
--      Status       --
-----------------------
function LuaVkApi:getStatus(userId, groupId)
  return self:invokeApi("status.get", {user_id=userId, group_id=groupId})
end

function LuaVkApi:setStatus(textVal, groupId)
  return self:invokeApi("status.set", {text=textVal, group_id=groupId})
end

-----------------------
--    Audio files    --
-----------------------
function LuaVkApi:getAudios(ownerId, albumId, audioIds, needUser, offsetVal, countVal)
  return self:invokeApi("audio.get", {owner_id=ownerId, album_id=albumId,
      audio_ids=audioIds, need_user=needUser, offset=offsetVal, count=countVal})
end

function LuaVkApi:getAudiosById(audioIds)
  return self:invokeApi("audio.getById", {audios=audioIds})
end

function LuaVkApi:getLyrics(lyricsId)
  return self:invokeApi("audio.getLyrics", {lyrics_id=lyricsId})
end

function LuaVkApi:searchAudios(query, autoComplete, lyricsVal, performerOnly, sortVal,
    searchOwn, offsetVal, countVal)
  return self:invokeApi("audio.search", {q=query, auto_compleate=autoComplete,
      lyrics=lyricsVal, performer_only=performerOnly, sort=sortVal, search_own=searchOwn,
      offset=offsetVal, count=countVal})
end

function LuaVkApi:getAudioUploadServer()
  return self:invokeApi("audio.getUploadServer")
end

function LuaVkApi:saveAudio(serverVal, audioVal, hashVal, artistVal, titleVal)
  return self:invokeApi("audio.save", {server=serverVal, audio=audioVal, hash=hashVal,
      artist=artistVal, title=titleVal})
end

function LuaVkApi:addAudio(audioId, ownerId, groupId, albumId)
  return self:invokeApi("audio.add", {audio_id=audioId, owner_id=ownerId, group_id=groupId,
      album_id=albumId})
end

function LuaVkApi:deleteAudio(audioId, ownerId)
  return self:invokeApi("audio.delete", {audio_id=audioId, owner_id=ownerId})
end

function LuaVkApi:editAudio(ownerId, audioId, artistVal, titleVal, textVal, genreId, noSearch)
  return self:invokeApi("audio.edit", {owner_id=ownerId, audio_id=audioId, artist=artistVal,
      title=titleVal, text=textVal, genre_id=genreId, no_search=noSearch})
end

function LuaVkApi:reorderAudio(audioId, ownerId, beforeVal, afterVal)
  return self:invokeApi("audio.reorder", {audio_id=audioId, owner_id=ownerId, before=beforeVal,
      after=afterVal})
end

function LuaVkApi:restoreAudio(audioId, ownerId)
  return self:invokeApi("audio.restore", {audio_id=audioId, owner_id=ownerId})
end

function LuaVkApi:getAudioAlbums(ownerId, offsetVal, countVal)
  return self:invokeApi("audio.getAlbums", {owner_id=ownerId, offset=offsetVal,
      count=countVal})
end

function LuaVkApi:addAudioAlbum(groupId, titleVal)
  return self:invokeApi("audio.addAlbum", {group_id=groupId, title=titleVal})
end

function LuaVkApi:editAudioAlbum(groupId, albumId, titleVal)
  return self:invokeApi("audio.editAlbum", {group_id=groupId, album_id=albumId,
      title=titleVal})
end

function LuaVkApi:deleteAudioAlbum(groupId, albumId)
  return self:invokeApi("audio.deleteAlbum", {group_id=groupId, album_id=albumId})
end

function LuaVkApi:moveAudioToAlbum(groupId, albumId, audioIds)
  return self:invokeApi("audio.moveToAlbum", {group_id=groupId, album_id=albumId,
      audio_ids=audioIds})
end

function LuaVkApi:setAudioBroadcast(audioVal, targetIds)
  return self:invokeApi("audio.setBroadcast", {audio=audioVal, target_ids=targetIds})
end

function LuaVkApi:getAudioBroadcastList(filterVal, isActive)
  return self:invokeApi("audio.getBroadcastList", {filter=filterVal,active=isActive})
end

function LuaVkApi:getAudioRecommendations(targetAudio, userId, offsetVal, countVal, isShuffle)
  return self:invokeApi("audio.getRecommendations", {target_audio=targetAudio, user_id=userId,
      offset=offsetVal, count=countVal, shuffle=isShuffle})
end

function LuaVkApi:getPopularAudios(onlyEng, genreId, offsetVal, countVal)
  return self:invokeApi("audio.getPopular", {only_eng=onlyEng, genre_id=genreId,
  	offset=offsetVal, count=countVal})
end

function LuaVkApi:getAudiosCount(ownerId)
  return self:invokeApi("audio.getCount", {owner_id=ownerId})
end

-----------------------
--       Pages       --
-----------------------
function LuaVkApi:getPages(ownerId, pageId, isGlobal, sitePreview, titleVal, needSource,
    needHtml)
  return self:invokeApi("pages.get", {owner_id=ownerId, page_id=pageId, global=isGlobal,
      site_preview=sitePreview, title=titleVal, need_source=needSource, need_html=needHtml})
end

function LuaVkApi:savePage(textVal, pageId, groupId, userId, titleVal)
  return self:invokeApi("pages.save", {text=textVal, page_id=pageId, group_id=groupId,
      user_id=userId, title=titleVal})
end

function LuaVkApi:savePageAccess(pageId, groupId, userId, viewVal, editVal)
  return self:invokeApi("pages.saveAccess", {page_id=pageId, group_id=groupId, user_id=userId,
      view=viewVal, edit=editVal})
end

function LuaVkApi:getPageHistory(pageId, groupId, userId)
  return self:invokeApi("pages.getHistory", {page_id=pageId, group_id=groupId, user_id=userId})
end

function LuaVkApi:getPageTitles(groupId)
  return self:invokeApi("pages.getTitles", {group_id=groupId})
end

function LuaVkApi:getPageVersion(versionId, groupId, userId, needHtml)
  return self:invokeApi("pages.getVersion", {version_id=versionId, group_id=groupId,
      user_id=userId, need_html=needHtml})
end

function LuaVkApi:parseWiki(textVal, groupId)
  return self:invokeApi("pages.parseWiki", {text=textVal, group_id=groupId})
end

function LuaVkApi:clearPageCache(urlVal)
  return self:invokeApi("pages.clearCache", {url=urlVal})
end

-----------------------
--    Communities    --
-----------------------
function LuaVkApi:isCommunityMember(groupId, userId, userIds, isExtended)
  return self:invokeApi("groups.isMember", {group_id=groupId, user_id=userId,
        user_ids=userIds, extended=isExtended})
end

function LuaVkApi:getCommunitiesById(groupIds, groupId, fieldsVal)
  return self:invokeApi("groups.getById", {group_ids=groupIds, group_id=groupId,
      fields=fieldsVal})
end

function LuaVkApi:getCommunities(userId, isExtended, filterVal, fieldsVal,
    offsetVal, countVal)
  return self:invokeApi("groups.get", {user_id=userId, extended=isExtended,
      filter=filterVal, fields=fieldsVal, offset=offsetVal, count=countVal})
end

function LuaVkApi:getCommunityMembers(groupId, sortVal, offsetVal, countVal,
    fieldsVal, filterVal)
  return self:invokeApi("groups.getMembers", {group_id=groupId, sort=sortVal,
      offset=offsetVal, count=countVal, fields=fieldsVal, filter=filterVal})
end

function LuaVkApi:joinCommunity(groupId, notSure)
  return self:invokeApi("groups.join", {group_id=groupId, not_sure=notSure})
end

function LuaVkApi:leaveCommunity(groupId)
  return self:invokeApi("groups.leave", {group_id=groupId})
end

function LuaVkApi:searchCommunities(query, typeVal, countryId, cityId, 
    isFuture, sortVal, offsetVal, countVal)
  return self:invokeApi("groups.search", {q=query, type=typeVal, country_id=countryId,
      city_id=cityId, future=isFuture, sort=sortVal, offset=offsetVal, count=countVal})
end

function LuaVkApi:getCommunitiesInvites(offsetVal, countVal, isExtended)
  return self:invokeApi("groups.getInvites", {offset=offsetVal, count=countVal,
      extended=isExtended})
end

function LuaVkApi:getInvitedUsers(groupId, offsetVal, countVal, fieldsVal, nameCase)
  return self:invokeApi("groups.getInvitedUsers", {group_id=groupId, offset=offsetVal,
      count=countVal, fields=fieldsVal, name_case=nameCase})
end

function LuaVkApi:banUserForCommunity(groupId, userId, endDate, reasonVal, commentVal,
    commentVisible)
  return self:invokeApi("groups.banUser", {group_id=groupId, user_id=userId, 
    end_date=endDate, reason=reasonVal, comment=commentVal, 
    comment_visible=commentVisible})
end

function LuaVkApi:unbanUserForCommunity(groupId, userId)
  return self:invokeApi("groups.unbanUser", {group_id=groupId, user_id=userId})
end

function LuaVkApi:getBannedUsersForCommunity(groupId, offsetVal, countVal, fieldsVal,
    userId)
  return self:invokeApi("groups.getBanned", {group_id=groupId, offset=offsetVal, 
      count=countVal, fields=fieldsVal, user_id=userId})
end

function LuaVkApi:createCommunity(titleVal, descriptionVal, typeVal, subtypeVal)
  return self:invokeApi("groups.create", {title=titleVal, description=descriptionVal,
      type=typeVal, subtype=subtypeVal})
end

function LuaVkApi:editCommunity(groupId, titleVal, descriptionVal, screenName,
    accessVal, websiteVal, subjectVal, emailVal, phoneVal, rssVal, eventStartDate, 
    eventFinishDate, eventGroupId, publicCategory, publicSubcategory, publicDate,
    wallVal, topicsVal, photosVal, videoVal, audioVal, linksVal, eventsVal, placesVal,
    contactsVal, docsVal, wikiVal)
  return self:invokeApi("groups.edit", {group_id=groupId, title=titleVal, 
      description=descriptionVal, screen_name=screenName, access=accessVal,
      website=websiteVal, subject=subjectVal, email=emailVal, phone=phoneVal, rss=rssVal,
      event_start_date=eventStartDate, event_finish_date=eventFinishDate,
      event_group_id=eventGroupId, public_category=publicCategory, 
      public_subcategory=publicSubcategory, public_date=publicDate, wall=wallVal,
      topics=topicsVal, photos=photosVal, video=videoVal, audio=audioVal, links=linksVal,
      events=eventsVal, places=placesVal, contacts=contactsVal, docs=docsVal,
      wiki=wikiVal})
end

function LuaVkApi:editPlace(groupId, titleVal, adressVal, countryId, cityId, latitudeVal,
    longitudeVal)
  return self:invokeApi("groups.editPlace", {group_id=groupId, title=titleVal, 
      adress=adressVal, country_id=countryId, city_id=cityId, latitude=latitudeVal,
      longitude=longitudeVal})
end

function LuaVkApi:getCommunitySettings(groupId)
  return self:invokeApi("groups.getSettings", {group_id=groupId})
end

function LuaVkApi:getCommunityRequests(groupId, offsetVal, countVal, fieldsVal)
  return self:invokeApi("groups.getRequests", {group_id=groupId, offset=offsetVal,
      count=countVal, fields=fieldsVal})
end

function LuaVkApi:editCommunityManager(groupId, userId, roleVal, isContact, 
    contactPosition, contactPhone, contactEmail)
  return self:invokeApi("groups.editManager", {group_id=groupId, user_id=userId,
      role=roleVal, is_contact=isContact, contact_position=contactPosition,
      contact_phone=contactPhone, contact_email=contactEmail})
end

function LuaVkApi:inviteToCommunity(groupId, userId)
  return self:invokeApi("groups.invite", {group_id=groupId, user_id=userId})
end

function LuaVkApi:addCommunityLink(groupId, linkVal, textVal)
  return self:invokeApi("groups.addLink", {group_id=groupId, link=linkVal,
      text=textVal})
end

function LuaVkApi:deleteCommunityLink(groupId, linkId)
  return self:invokeApi("groups.deleteLink", {group_id=groupId, link_id=linkId})
end

function LuaVkApi:editCommunityLink(groupId, linkId, textVal)
  return self:invokeApi("groups.editLink", {group_id=groupId, link_id=linkId,
      text=textVal})
end

function LuaVkApi:reorderCommunityLink(groupId, linkId, afterVal)
  return self:invokeApi("groups.reorderLink", {group_id=groupId, link_id=linkId,
      after=afterVal})
end

function LuaVkApi:removeUserFromCommunity(groupId, userId)
  return self:invokeApi("groups.removeUser", {group_id=groupId, user_id=userId})
end

function LuaVkApi:approveUserRequestToCommunity(groupId, userId)
  return self:invokeApi("groups.approveRequest", {group_id=groupId, user_id=userId})
end

function LuaVkApi:setGroupCallbackSettings(groupId, messageNew, photoNew, audioNew,
	videoNew, wallReplyNew, wallReplyEdit, wallPostNew, boardPostNew, boardPostEdit,
	boardPostRestore, boardPostDelete, photoCommentNew, videoCommentNew, marketCommentNew,
	groupJoin, groupLeave)
  return self:invokeApi("groups.setCallbackSettings", {group_id=groupId, message_new=messageNew,
  	photo_new=photoNew, audio_new=audioNew, video_new=videoNew, wall_reply_new=wallReplyNew,
  	wall_reply_edit=wallReplyEdit, wall_post_new=wallPostNew, board_post_new=boardPostNew,
  	board_post_edit=boardPostEdit, board_post_restore=boardPostRestore,
  	board_post_delete=boardPostDelete, photo_comment_new=photoCommentNew,
  	video_comment_new=videoCommentNew, market_comment_new=marketCommentNew, group_join=groupJoin,
  	group_leave=groupLeave})
end

function LuaVkApi:setCallbackServerSettings(groupId, secretKey)
  return self:invokeApi("groups.setCallbackServerSettings", {group_id=groupId, secret_key=secretKey})
end

function LuaVkApi:setCallbackServer(groupId, serverUrl)
  return self:invokeApi("groups.setCallbackServer", {group_id=groupId, server_url=serverUrl})
end

function LuaVkApi:getCallbackSettings(groupId)
  return self:invokeApi("groups.getCallbackSettings", {group_id=groupId})
end

function LuaVkApi:getCallbackServerSettings(groupId)
  return self:invokeApi("groups.getCallbackServerSettings", {group_id=groupId})
end

function LuaVkApi:getCallbackConfirmationCode(groupId)
  return self:invokeApi("groups.getCallbackConfirmationCode", {group_id=groupId})
end

function LuaVkApi:getCallbackConfirmationCode(groupId)
  return self:invokeApi("groups.getCallbackConfirmationCode", {group_id=groupId})
end

function LuaVkApi:getGroupCatalogInfo(isExtended, subcategoriesVal)
  return self:invokeApi("groups.getCatalogInfo", {extended=isExtended,
  	subcategories=subcategoriesVal})
end

function LuaVkApi:getGroupCatalog(categoryId, subcategoryId)
  return self:invokeApi("groups.getCatalogInfo", {category_id=categoryId,
  	subcategory_id=subcategoryId})
end

-----------------------
--      Boards       --
-----------------------
function LuaVkApi:getBoardTopics(groupId, topicIds, orderVal, offsetVal, countVal, 
    isExtended, previewVal, previewLength)
  return self:invokeApi("board.getTopics", {group_id=groupId, topic_ids=topicIds,
      order=orderVal, offset=offsetVal, count=countVal, extended=isExtended,
      preview=previewVal, preview_length=previewLength})
end

function LuaVkApi:getBoardComments(groupId, topicId, needLikes, startCommentId, offsetVal,
    countVal, isExtended, sortVal)
  return self:invokeApi("board.getComments", {group_id=groupId, topic_id=topicId,
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal, count=countVal,
      extended=isExtended, sort=sortVal})
end

function LuaVkApi:addBoardTopic(groupId, titleVal, textVal, fromGroup, attachmentsVal)
  return self:invokeApi("board.addTopic", {group_id=groupId, title=titleVal,
      text=textVal, from_group=fromGroup, attachments=attachmentsVal})
end

function LuaVkApi:addCommentToBoardTopic(groupId, topicId, textVal, attachmentsVal, fromGroup,
    stickerId)
  return self:invokeApi("board.addComment", {group_id=groupId, topic_id=topicId,
      text=textVal, attachments=attachmentsVal, from_group=fromGroup, sticker_id=stickerId})
end

function LuaVkApi:deleteBoardTopic(groupId, topicId)
  return self:invokeApi("board.deleteTopic", {group_id=groupId, topic_id=topicId})
end

function LuaVkApi:editBoardTopic(groupId, topicId, titleVal)
  return self:invokeApi("board.editTopic", {group_id=groupId, topic_id=topicId,
      title=titleVal})
end

function LuaVkApi:editBoardTopicComment(groupId, topicId, commentId, textVal, attachmentsVal)
  return self:invokeApi("board.editComment", {group_id=groupId, topic_id=topicId,
      comment_id=commentId, text=textVal, attachments=attachmentsVal})
end

function LuaVkApi:restoreBoardTopicComment(groupId, topicId, commentId)
  return self:invokeApi("board.restoreComment", {group_id=groupId, topic_id=topicId,
      comment_id=commentId})
end

function LuaVkApi:deleteBoardTopicComment(groupId, topicId, commentId)
  return self:invokeApi("board.deleteComment", {group_id=groupId, topic_id=topicId,
      comment_id=commentId})
end

function LuaVkApi:openBoardTopic(groupId, topicId)
  return self:invokeApi("board.openTopic", {group_id=groupId, topic_id=topicId})
end

function LuaVkApi:closeBoardTopic(groupId, topicId)
  return self:invokeApi("board.closeTopic", {group_id=groupId, topic_id=topicId})
end

function LuaVkApi:fixBoardTopic(groupId, topicId)
  return self:invokeApi("board.fixTopic", {group_id=groupId, topic_id=topicId})
end

function LuaVkApi:unfixBoardTopic(groupId, topicId)
  return self:invokeApi("board.unfixTopic", {group_id=groupId, topic_id=topicId})
end

-----------------------
--      Videos       --
-----------------------
function LuaVkApi:getVideosInfo(ownerId, videoIds, albumId, countVal, offsetVal,
    isExtended)
  return self:invokeApi("video.get", {owner_id=ownerId, videos=videoIds,
      album_id=albumId, count=countVal, offset=offsetVal, extended=isExtended})
end

function LuaVkApi:editVideoInfo(ownerId, videoId, nameVal, descVal, privacyView,
    privacyComment, noComments)
  return self:invokeApi("video.edit", {owner_id=ownerId, video_id=videoId,
      name=nameVal, desc=descVal, privacy_view=privacyView, 
      privacy_comment=privacyComment, no_comments=noComments})
end

function LuaVkApi:addVideo(targetId, videoId, ownerId)
  return self:invokeApi("video.add", {target_id=targetId, owner_id=ownerId,
      video_id=videoId})
end

function LuaVkApi:saveVideo(nameVal, descVal, isPrivate, wallPost, linkVal,
    groupId, albumId, privacyView, privacyComment, noComments, isRepeat)
  return self:invokeApi("video.save", {name=nameVal, description=descVal,
      is_private=isPrivate, wallpost=wallPost, link=linkVal, group_id=groupId,
      album_id=albumId, privacy_view=privacyView, privacy_comment=privacyComment,
      no_comments=noComments, is_repeat=isRepeat})
end

function LuaVkApi:deleteVideo(videoId, ownerId, targetId)
  return self:invokeApi("video.delete", {video_id=videoId, owner_id=ownerId,
      target_id=targetId})
end

function LuaVkApi:restoreVideo(videoId, ownerId)
  return self:invokeApi("video.restore", {video_id=videoId, owner_id=ownerId})
end

function LuaVkApi:searchVideos(query, sortVal, isHD, isAdult, filtersVal, searchOwn,
    offsetVal, longerThan, shorterThan, countVal, isExtended)
  return self:invokeApi("video.search", {q=query, sort=sortVal, hd=isHD,
      adult=isAdult, filters=filtersVal, search_own=searchOwn, offset=offsetVal,
      longer=longerThan, shorter=shorterThan, count=countVal, extended=isExtended})
end

function LuaVkApi:getUserVideos(userId, offsetVal, countVal, isExtended)
  return self:invokeApi("video.getUserVideos", {user_id=userId, offset=offsetVal, 
      count=countVal, extended=isExtended})
end

function LuaVkApi:getVideoAlbums(ownerId, offsetVal, countVal, isExtended, needSystem)
  return self:invokeApi("video.getAlbums", {owner_is=ownerId, offset=offsetVal, 
      count=countVal, extended=isExtended, need_system=needSystem})
end

function LuaVkApi:getVideoAlbumById(ownerId, albumId)
  return self:invokeApi("video.getAlbumById", {owner_is=ownerId, album_id=albumId})
end

function LuaVkApi:addVideoAlbum(groupId, titleVal, privacyVal)
  return self:invokeApi("video.addAlbum", {group_iid=groupId, title=titleVal,
      privacy=privacyVal})
end

function LuaVkApi:editVideoAlbum(groupId, albumId, titleVal, privacyVal)
  return self:invokeApi("video.editAlbum", {group_id=groupId, album_id=albumId, 
      title=titleVal, privacy=privacyVal})
end

function LuaVkApi:deleteVideoAlbum(groupId, albumId)
  return self:invokeApi("video.deleteAlbum", {group_id=groupId, album_id=albumId})
end

function LuaVkApi:reorderVideoAlbums(ownerId, albumId, beforeVal, afterVal)
  return self:invokeApi("video.reorderAlbums", {owner_id=ownerId, album_id=albumId,
      before=beforeVal, after=afterVal})
end

function LuaVkApi:addVideoToAlbum(targetId, albumId, albumIds, ownerId, videoId)
  return self:invokeApi("video.addToAlbum", {target_id=targetId, album_id=albumId,
      album_ids=albumIds, owner_id=ownerId, video_id=videoId})
end

function LuaVkApi:removeVideoFromAlbum(targetId, albumId, albumIds, ownerId, videoId)
  return self:invokeApi("video.removeFromAlbum", {target_id=targetId, album_id=albumId,
      album_ids=albumIds, owner_id=ownerId, video_id=videoId})
end

function LuaVkApi:getAlbumsByVideo(targetId, ownerId, videoId, isExtended)
  return self:invokeApi("video.getAlbumsByVideo", {target_id=targetId, owner_id=ownerId, 
      video_id=videoId, extended=isExtended})
end

function LuaVkApi:getVideoComments(ownerId, videoId, needLikes, startCommentId, offsetVal,
    countVal, sortVal, isExtended)
  return self:invokeApi("video.getComments", {owner_id=ownerId, video_id=videoId, 
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal,
      count=countVal, sort=sortVal, extended=isExtended})
end

function LuaVkApi:createVideoComment(ownerId, videoId, messageVal, attachmentsVal,
    fromGroup, replyToComment, stickerId)
  return self:invokeApi("video.createComment", {owner_id=ownerId, video_id=videoId, 
      message=messageVal, attachments=attachmentsVal, from_group=fromGroup,
      reply_to_comment=replyToComment, sticker_id=stickerId})
end

function LuaVkApi:deleteVideoComment(ownerId, commentId)
  return self:invokeApi("video.deleteComment", {owner_id=ownerId, comment_id=commentId})
end

function LuaVkApi:restoreVideoComment(ownerId, commentId)
  return self:invokeApi("video.restoreComment", {owner_id=ownerId, comment_id=commentId})
end

function LuaVkApi:editVideoComment(ownerId, commentId, messageVal, attachmentsVal)
  return self:invokeApi("video.editComment", {owner_id=ownerId, comment_id=commentId,
      message=messageVal, attachments=attachmentsVal})
end

function LuaVkApi:getVideoTags(ownerId, videoId)
  return self:invokeApi("video.getTags", {owner_id=ownerId, video_id=videoId})
end

function LuaVkApi:putVideoTag(userId, ownerId, videoId, taggedName)
  return self:invokeApi("video.putTag", {user_id=userId, owner_id=ownerId, 
      video_id=videoId, tagged_name=taggedName})
end

function LuaVkApi:removeVideoTag(tagId, ownerId, videoId)
  return self:invokeApi("video.removeTag", {tag_id=tagId, owner_id=ownerId, 
      video_id=videoId})
end

function LuaVkApi:getNewVideoTags(offsetVal, countVal)
  return self:invokeApi("video.getNewTags", {offset=offsetVal, count=countVal})
end

function LuaVkApi:reportVideo(ownerId, videoId, reasonVal, commentVal, query)
  return self:invokeApi("video.report", {owner_id=ownerId, video_id=videoId,
      reason=reasonVal, comment=commentVal, search_query=query})
end

function LuaVkApi:reportVideoComment(ownerId, commentId, reasonVal)
  return self:invokeApi("video.reportComment", {owner_id=ownerId, comment_id=commentId,
      reason=reasonVal})
end

function LuaVkApi:hideVideoCatalogSection(sectionId)
  return self:invokeApi("video.hideCatalogSection", {section_id=sectionId})
end

function LuaVkApi:getVideoCatalogSection(sectionId, fromVal, countVal, isExtended)
  return self:invokeApi("video.getCatalogSection", {section_id=sectionId, from=fromVal,
  	count=countVal, extended=isExtended})
end

function LuaVkApi:getVideoCatalog(countVal, itemsCount, fromVal, isExtended, filtersVal,
	isGrouped)
  return self:invokeApi("video.getCatalog", {count=countVal, items_count=itemsCount,
  	form=fromVal, extended=isExtended, filters=filtersVal, grouped=isGrouped})
end

function LuaVkApi:reorderVideos(ownerId, videoId, targetId, albumId, beforeOwnerId,
	beforeVideoId, afterOwnerId, afterVideoId)
  return self:invokeApi("video.reorderVideos", {owner_id=ownerId, video_id=videoId,
  	target_id=targetId, album_id=albumId, before_owner_id=beforeOwnerId,
  	before_video_id=beforeVideoId, after_owner_id=afterOwnerId,
  	after_video_id=afterVideoId})
end

-----------------------
--       Notes       --
-----------------------
function LuaVkApi:getNotes(noteIds, userId, offsetVal, countVal, sortVal)
  return self:invokeApi("notes.get", {note_ids=noteIds, user_id=userId,
      offset=offsetVal, count=countVal, sort=sortVal})
end

function LuaVkApi:getNotesById(noteId, userId, needWiki)
  return self:invokeApi("notes.getById", {note_id=noteId, user_id=userId,
      need_wiki=needWiki})
end

function LuaVkApi:getFriendsNotes(offsetVal, countVal)
  return self:invokeApi("notes.getFriendsNotes", {offset=offsetVal, count=countVal})
end

function LuaVkApi:addNote(titleVal, textVal, privacyView, privacyComment)
  return self:invokeApi("notes.add", {title=titleVal, text=textVal,
      privacy_view=privacyView, privacy_comment=privacyComment})
end

function LuaVkApi:editNote(noteId, titleVal, textVal, privacyView, privacyComment)
  return self:invokeApi("notes.edit", {note_id=noteId, title=titleVal, text=textVal,
      privacy_view=privacyView, privacy_comment=privacyComment})
end

function LuaVkApi:deleteNote(noteId)
  return self:invokeApi("notes.delete", {note_id=noteId})
end

function LuaVkApi:getNoteComments(noteId, ownerId, sortVal, offsetVal, countVal)
  return self:invokeApi("notes.getComments", {note_id=noteId, owner_id=ownerId,
      sort=sortVal, offset=offsetVal, count=countVal})
end

function LuaVkApi:createNoteComment(noteId, ownerId, replyTo, messageVal)
  return self:invokeApi("notes.createComment", {note_id=noteId, owner_id=ownerId,
      reply_to=replyTo, message=messageVal})
end

function LuaVkApi:editNoteComment(commentId, ownerId, messageVal)
  return self:invokeApi("notes.editComment", {comment_id=commentId, owner_id=ownerId,
      message=messageVal})
end

function LuaVkApi:deleteNoteComment(commentId, ownerId)
  return self:invokeApi("notes.deleteComment", {comment_id=commentId, owner_id=ownerId})
end 

function LuaVkApi:restoreNoteComment(commentId, ownerId)
  return self:invokeApi("notes.restoreComment", {comment_id=commentId, owner_id=ownerId})
end 

-----------------------
--      Places       --
-----------------------
function LuaVkApi:addPlace(typeVal, titleVal, latitudeVal, longitudeVal, countryVal,
    cityVal, adressVal)
  return self:invokeApi("places.add", {type=typeVal, title=titleVal, latitude=latitudeVal,
      longitude=longitudeVal, country=countryVal, city=cityVal, addres=adressVal})
end

function LuaVkApi:getPlacesById(placesVal)
  return self:invokeApi("places.getById", {places=placesVal})
end

function LuaVkApi:searchPlaces(query, cityId, latitudeVal, longitudeVal, radiusVal,
    offsetVal, countVal)
  return self:invokeApi("places.search", {q=query, city=cityId, latitude=latitudeVal,
      longitude=longitudeVal, radius=radiusVal, offset=offsetVal, count=countVal})
end

function LuaVkApi:checkin(placeId, textVal, latitudeVal, longitudeVal, friendsOnly,
    servicesVal)
  return self:invokeApi("places.checkin", {place_id=placeId, text=textVal,
      latitude=latitudeVal, longitude=longitudeVal, friends_only=friendsOnly,
      services=servicesVal})
end

function LuaVkApi:getCheckins(latitudeVal, longitudeVal, placeVal, userId, offsetVal,
    countVal, timestampVal, friendsOnly, needPlaces)
  return self:invokeApi("places.getCheckins", {latitude=latitudeVal, longitude=longitudeVal,
      place=placeVal, user_id=userId, offset=offsetVal, count=countVal,
      timestamp=timestampVal, friends_only=friendsOnly, need_paces=needPlaces})
end

function LuaVkApi:getPlacesTypes()
  return self:invokeApi("places.getTypes")
end

-----------------------
--      Account      --
-----------------------
function LuaVkApi:getUserCounters(fiterVal)
  return self:invokeApi("account.getCounters", {filter=fiterVal})
end

function LuaVkApi:setAccountNameInMenu(userId, nameVal)
  return self:invokeApi("account.setNameInMenu", {user_id=userId, name=nameVal})
end

function LuaVkApi:setAccountOnline(voipVal)
  return self:invokeApi("account.setOnline", {voip=voipVal})
end

function LuaVkApi:setAccountOffline()
  return self:invokeApi("account.setOffline")
end

function LuaVkApi:lookupAccountContacts(contactsVal, serviceVal, mycontactVal, returnAll,
    fieldsVal)
  return self:invokeApi("account.lookupContacts", {contacts=contactsVal, service=serviceVal,
	  mycontact=mycontactVal, return_all=returnAll, fields=fieldsVal})
end

function LuaVkApi:registerDevice(tokenVal, deviceModel, deviceYear, deviceId, systemVersion,
    settingsVal, sandboxVal)
  return self:invokeApi("account.registerDevice", {token=tokenVal, device_model=deviceModel,
      device_year=deviceYear, device_id=deviceId, system_version=systemVersion, settings=settingsVal,
	  sandbox=sandboxVal})
end

function LuaVkApi:unregisterDevice(deviceId, isSandbox)
  return self:invokeApi("account.unregisterDevice", {device_id=deviceId, sandbox=isSandbox})
end

function LuaVkApi:setSilenceMode(deviceId, timeVal, peerId, soundVal)
  return self:invokeApi("account.setSilenceMode", {device_id=deviceId, time=timeVal,
	  peer_id=peerId, sound=soundVal})
end

function LuaVkApi:getPushSettings(deviceId)
  return self:invokeApi("account.getPushSettings", {device_id=deviceId})
end

function LuaVkApi:setPushSettings(deviceId, settingsVal, keyStr, valueStr)
  return self:invokeApi("account.setPushSettings", {device_id=deviceId, settings=settingsVal,
	  key=keyStr, value=valueStr})
end

function LuaVkApi:getAppPermissions(userId)
  return self:invokeApi("account.getAppPermissions", {user_id=userId})
end

function LuaVkApi:getActiveOffers(offsetVal, countVal)
  return self:invokeApi("account.getActiveOffers", {offset=offsetVal, count=countVal})
end

function LuaVkApi:banUser(userId)
  return self:invokeApi("account.banUser", {user_id=userId})
end

function LuaVkApi:unbanUser(userId)
  return self:invokeApi("account.unbanUser", {user_id=userId})
end

function LuaVkApi:getBanned(offsetVal, countVal)
  return self:invokeApi("account.getBanned", {offset=offsetVal, count=countVal})
end

function LuaVkApi:getInfo(fieldsVal)
  return self:invokeApi("account.getInfo", {fields=fieldsVal})
end

function LuaVkApi:setInfo(nameVal, val)
  return self:invokeApi("account.setInfo", {name=nameVal, value=val})
end

function LuaVkApi:changePassword(restoreSid, changePasswordHash, oldPassword, newPassword)
  return self:invokeApi("account.changePassword", {restore_sid=restoreSid,
	  change_password_hash=changePasswordHash, old_password=oldPassword, new_password=newPassword})
end

function LuaVkApi:getProfileInfo()
  return self:invokeApi("account.getProfileInfo")
end

function LuaVkApi:saveProfileInfo(firstName, lastName, maidenName, screenName, cancelRequestId,
	sexVal, relationVal, relationPartnerId, bdateVal, bdateVisibility, homeTown, countryId,
	cityId, statusVal)
  return self:invokeApi("account.saveProfileInfo", {first_name=firstName, last_name=lastName,
	  maiden_name=maidenName, screen_name=screenName, cancel_request_id=cancelRequestId,
	  sex=sexVal, relation=relationVal, relation_partner_id=relationPartnerId, bdate=bdateVal,
	  bdate_visibility=bdateVisibility, home_town=homeTown, counry_id=countryId,
	  city_id=cityId, status=statusVal})
end

-----------------------
--     Messages      --
-----------------------
function LuaVkApi:getPrivateMessages(outVal, offsetVal, countVal, timeOffset, filtersVal,
    previewLength, lastMessageId)
  return self:invokeApi("messages.get", {out=outVal, offset=offsetVal, count=countVal,
      time_offset=timeOffset, filters=filtersVal, preview_length=previewLength, 
      last_message_id=lastMessageId})
end

function LuaVkApi:getDialogs(offsetVal, countVal, startMessageId, previewLength, unreadVal)
  return self:invokeApi("messages.getDialogs", {offset=offsetVal, count=countVal,
      start_message_id=startMessageId, preview_length=previewLength, unread=unreadVal})
end

function LuaVkApi:getMessagesById(messageIds, previewLength)
  return self:invokeApi("messages.getById", {message_ids=messageIds, preview_length=previewLength})
end

function LuaVkApi:searchMessages(query, previewLength, offsetVal, countVal)
  return self:invokeApi("messages.search", {q=query, preview_length=previewLength,
      offset=offsetVal, count=countVal})
end

function LuaVkApi:getMessageHistory(offsetVal, countVal, userId, chatId, peerId, startMessageId,
    revVal)
  return self:invokeApi("messages.getHistory", {offset=offsetVal, count=countVal, user_id=userId,
      chat_id=chatId, peer_id=peerId, start_message_id=startMessageId, rev=revVal})
end

function LuaVkApi:sendMessage(userId, peerId, domainVal, chatId, userIds, messageStr, randomId,
    latVal, longVal, attachmentVal, forwardMessages, stickerId)
  return self:invokeApi("messages.send", {user_id=userId, peer_id=peerId, domain=domainVal,
      chat_id=chatId, user_ids=userIds, message=messageStr, random_id=randomId, lat=latVal,
      long=longVal, attachment=attachmentVal, forward_messages=forwardMessages, sticker_id=stickerId})
end

function LuaVkApi:deleteMessages(messageIds)
  return self:invokeApi("messages.delete", {message_ids=messageIds})
end

function LuaVkApi:deleteDialog(userId, peerId, offsetVal, countVal)
  return self:invokeApi("messages.deleteDialog", {user_id=userId, peer_id=peerId, offset=offsetVal,
      count=countVal})
end

function LuaVkApi:restoreMessage(messageId)
  return self:invokeApi("messages.restore", {message_id=messageId})
end

function LuaVkApi:markAsRead(messageIds, peerId, startMessageId)
  return self:invokeApi("messages.markAsRead", {message_ids=messageIds, peer_id=peerId,
      start_message_id=startMessageId})
end

function LuaVkApi:markAsImportant(messageIds, isImportant)
  return self:invokeApi("messages.markAsImportant", {message_ids=messageIds, important=isImportant})
end

function LuaVkApi:getLongPollServer(useSSL, needPts)
  return self:invokeApi("messages.getLongPollServer", {use_ssl=useSSL, need_pts=needPts})
end

function LuaVkApi:getLongPollHistory(tsVal, ptsVal, previewLength, isOnlines, fieldsVal, 
    eventsLimit, msgsLimit, maxMsgId)
  return self:invokeApi("messages.getLongPollHistory", {ts=tsVal, pts=ptsVal, 
      preview_length=previewLength, onlines=isOnlines, fields=fieldsVal, events_limit=eventsLimit,
      msgs_limit=msgsLimit, max_msg_id=maxMsgId})
end

function LuaVkApi:getChat(chatId, chatIds, fieldsVal, nameCase)
  return self:invokeApi("messages.getChat", {chat_id=chatId, chat_ids=chatIds, fields=fieldsVal,
      name_case=nameCase})
end

function LuaVkApi:createChat(userIds, titleVal)
  return self:invokeApi("messages.createChat", {user_ids=userIds, title=titleVal})
end

function LuaVkApi:editChat(chatId, titleVal)
  return self:invokeApi("messages.editChat", {chat_id=chatId, title=titleVal})
end

function LuaVkApi:getChatUsers(chatId, chatIds, fieldsVal, nameCase)
  return self:invokeApi("messages.getChatUsers", {chat_id=chatId, chat_ids=chatIds,
      fields=fieldsVal, name_case=nameCase})
end

function LuaVkApi:setActivity(userId, typeVal, peerId)
  return self:invokeApi("messages.setActivity", {user_id=userId, type=typeVal,
      peer_id=peerId})
end

function LuaVkApi:searchDialogs(query, limitVal, fieldsVal)
  return self:invokeApi("messages.searchDialogs", {q=query, limit=limitVal,
      fields=fieldsVal})
end

function LuaVkApi:addChatUser(chatId, userId)
  return self:invokeApi("messages.addChatUser", {chat_id=chatId, user_id=userId})
end

function LuaVkApi:removeChatUser(chatId, userId)
  return self:invokeApi("messages.removeChatUser", {chat_id=chatId, user_id=userId})
end

function LuaVkApi:getLastActivity(userId)
  return self:invokeApi("messages.getLastActivity", {user_id=userId})
end

function LuaVkApi:setChatPhoto(fileVal)
  return self:invokeApi("messages.setChatPhoto", {file=fileVal})
end

function LuaVkApi:deleteChatPhoto(chatId)
  return self:invokeApi("messages.deleteChatPhoto", {chat_id=chatId})
end

function LuaVkApi:getMessageHistoryAttachments(peerId, mediaType, startFrom,
	countVal, photoSizes, fieldsVal)
  return self:invokeApi("messages.getHistoryAttachments", {peer_id=peerId,
  	media_type=mediaType, start_from=startFrom, count=countVal, photo_sizes=photoSizes,
  	fields=fieldsVal})
end

-----------------------
--      News         --
-----------------------
function LuaVkApi:getNewsFeed(filtersVal, returnBanned, startTime, endTime, maxPhotos,
    sourceIds, startFrom, countVal, fieldsVal)
  return self:invokeApi("newsfeed.get", {filters=filtersVal, return_banned=returnBanned, 
      start_time=startTime, end_time=endTime, max_photos=maxPhotos, source_ids=sourceIds, 
      start_from=startFrom, count=countVal, fields=fieldsVal})
end

function LuaVkApi:getRecommendedNews(startTime, endTime, maxPhotos, startFrom, countVal,
    fieldsVal)
  return self:invokeApi("newsfeed.getRecommended", {start_time=startTime, end_time=endTime,
      max_photos=maxPhotos, start_from=startFrom, count=countVal, fields=fieldsVal})
end

function LuaVkApi:getNewsComments(countVal, filtersVal, repostsVal, startTime, endTime, 
    lastCommentsCount, startFrom, fieldsVal)
  return self:invokeApi("newsfeed.getComments", {count=countVal, filters=filtersVal,
      reposts=repostsVal, start_time=startTime, end_time=endTime,
      last_comments_count=lastCommentsCount, start_from=startFrom, fields=fieldsVal})
end

function LuaVkApi:getUserMentions(ownerId, startTime, endTime, offsetVal, countVal)
  return self:invokeApi("newsfeed.getMentions", {owner_id=ownerId, start_time=startTime,
      end_time=endTime, offset=offsetVal, count=countVal})
end

function LuaVkApi:getBanned(isExtended, fieldsVal, nameCase)
  return self:invokeApi("newsfeed.getBanned", {extended=isExtended, fields=fieldsVal,
      name_case=nameCase})
end

function LuaVkApi:addBan(userIds, groupIds)
  return self:invokeApi("newsfeed.addBan", {user_ids=userIds, group_ids=groupIds})
end 

function LuaVkApi:deleteBan(userIds, groupIds)
  return self:invokeApi("newsfeed.deleteBan", {user_ids=userIds, group_ids=groupIds})
end 

function LuaVkApi:ignoreItem(typeVal, ownerId, itemId)
  return self:invokeApi("newsfeed.ignoreItem", {type=typeVal, ownner_id=ownerId,
      item_id=itemId})
end 

function LuaVkApi:unignoreItem(typeVal, ownerId, itemId)
  return self:invokeApi("newsfeed.unignoreItem", {type=typeVal, ownner_id=ownerId,
      item_id=itemId})
end 

function LuaVkApi:searchNews(keyWord, isExtended, countVal, latitudeVal, longitudeVal,
    startTime, endTime, startFrom, fieldsVal)
  return self:invokeApi("newsfeed.search", {q=keyWord, extended=isExtended, count=countVal,
      latitude=latitudeVal, longitude=longitudeVal, start_time=startTime, endTime=endTime, 
      start_from=startFrom, fields=fieldsVal})
end

function LuaVkApi:getLists(listIds, isExtended)
  return self:invokeApi("newsfeed.getLists", {list_ids=listIds, extended=isExtended})
end

function LuaVkApi:saveList(listId, titleVal, sourceIds, noReposts)
  return self:invokeApi("newsfeed.saveList", {list_id=listId, title=titleVal, 
  source_ids=sourceIds, no_reposts=noReposts})
end 

function LuaVkApi:deleteList(listId)
  return self:invokeApi("newsfeed.deleteList", {list_id=listId})
end

function LuaVkApi:unsubscribe(typeVal, ownerId, itemId)
  return self:invokeApi("newsfeed.unsubscribe", {type=typeVal, owner_id=ownerId,
      item_id=itemId})
end

function LuaVkApi:getSuggestedSources(offsetVal, countVal, shuffleVal, fieldsVal)
  return self:invokeApi("newsfeed.getSuggestedSources", {offset=offsetVal, count=countVal,
      shuffle=shuffleVal, fieldsVal})
end

-----------------------
--      Likes        --
-----------------------
function LuaVkApi:getLikerIds(typeVal, ownerId, itemId, pageUrl, filterVal,
    friendsOnly, isExtended, offsetVal, countVal, skipOwn)
  return self:invokeApi("likes.getList", {type=typeVal, owner_id=ownerId,
      item_id=itemId, page_url=pageUrl, filter=filterVal, friends_only=friendsOnly,
      extended=isExtended, offset=offsetVal, count=countVal, skip_own=skipOwn})
end

function LuaVkApi:putLike(entityType, ownerId, itemId, accessKey, refStr)
  return self:invokeApi("likes.add", {type=entityType, owner_id=ownerId,
      item_id=itemId, access_key=accessKey, ref=refStr})
end

function LuaVkApi:deleteLike(entityType, ownerId, itemId)
  return self:invokeApi("likes.delete", {type=entityType, owner_id=ownerId,
      item_id=itemId})
end

function LuaVkApi:isLiked(userId, entityType, ownerId, itemId)
  return self:invokeApi("likes.isLiked", {user_id=userId, type=entityType,
      owner_id=ownerId, item_id=itemId})
end

-----------------------
--      Polls        --
-----------------------
function LuaVkApi:getPollById(ownerId, isBoard, pollId)
  return self:invokeApi("polls.getById", {owner_id=ownerId, is_board=isBoard, 
      poll_id=pollId})
end

function LuaVkApi:addVote(ownerId, pollId, answerId, isBoard)
  return self:invokeApi("polls.addVote", {owner_id=ownerId, poll_id=pollId, 
      answer_id=answerId, is_board=isBoard})
end

function LuaVkApi:deleteVote(ownerId, pollId, answerId, isBoard)
  return self:invokeApi("polls.deleteVote", {owner_id=ownerId, poll_id=pollId, 
      answer_id=answerId, is_board=isBoard})
end

function LuaVkApi:getVoters(ownerId, pollId, answerIds, isBoard, friendsOnly, offsetVal,
    countVal, fieldsVal, nameCase)
  return self:invokeApi("polls.getVoters", {owner_id=ownerId, poll_id=pollId, 
      answer_ids=answerIds, is_board=isBoard, friends_only=friendsOnly, offset=offsetVal,
      count=countVal, fields=fieldsVal, name_case=nameCase})
end

function LuaVkApi:createPoll(questionStr, isAnonymous, ownerId, addAnswers)
  return self:invokeApi("polls.create", {question=questionStr, is_anonymous=isAnonymous, 
      owner_id=ownerId, add_answers=addAnswers})
end

function LuaVkApi:editPoll(ownerId, pollId, questionStr, addAnswers, editAnswers, 
    deleteAnswers)
  return self:invokeApi("polls.edit", {owner_id=ownerId, poll_id=pollId,
      question=questionStr, add_answers=addAnswers, edit_answers=editAnswers,
      delete_answers=deleteAnswers})
end

-----------------------
--    Documents      --
-----------------------
function LuaVkApi:getDocuments(countVal, offsetVal, ownerId)
  return self:invokeApi("docs.get", {count=countVal, offset=offsetVal, owner_id=ownerId})
end

function LuaVkApi:getDocumentsById(docsVal)
  return self:invokeApi("docs.getById", {docs=docsVal})
end

function LuaVkApi:getUploadServer(groupId)
  return self:invokeApi("docs.getUploadServer", {group_id=groupId})
end

function LuaVkApi:getWallUploadServer(groupId)
  return self:invokeApi("docs.getWallUploadServer", {group_id=groupId})
end

function LuaVkApi:saveDoc(docFile, titleVal, tagsVal)
  return self:invokeApi("docs.save", {file=docFile, title=titleVal, tags=tagsVal})
end

function LuaVkApi:deleteDoc(ownerId, docId)
  return self:invokeApi("docs.delete", {owner_id=ownerId, doc_id=docId})
end

function LuaVkApi:addDoc(ownerId, docId, accessKey)
  return self:invokeApi("docs.add", {owner_id=ownerId, doc_id=docId, access_key=accessKey})
end

function LuaVkApi:getDocTypes(ownerId)
  return self:invokeApi("docs.getTypes", {owner_id=ownerId})
end

function LuaVkApi:searchDocs(queryStr, countVal, offsetVal)
  return self:invokeApi("docs.search", {q=queryStr, count=countVal, offset=offsetVal})
end

function LuaVkApi:editDoc(ownerId, docId, titleVal, tagsVal)
  return self:invokeApi("docs.edit", {owner_id=ownerId, doc_id=docId, title=titleVal,
  	tags=tagsVal})
end

-----------------------
--    Favorites      --
-----------------------
function LuaVkApi:getBookmarkers(offsetVal, countVal)
  return self:invokeApi("fave.getUsers", {offset=offsetVal, count=countVal})
end

function LuaVkApi:getLikedPhotos(offsetVal, countVal, photoSizes)
  return self:invokeApi("fave.getPhotos", {offset=offsetVal, count=countVal,
      photo_sizes=photoSizes})
end

function LuaVkApi:getLikedPosts(offsetVal, countVal, isExtended)
  return self:invokeApi("fave.getPosts", {offset=offsetVal, count=countVal,
      extended=isExtended})
end

function LuaVkApi:getLikedVideos(offsetVal, countVal, isExtended)
  return self:invokeApi("fave.getVideos", {offset=offsetVal, count=countVal,
      extended=isExtended})
end

function LuaVkApi:getLikedLinks(offsetVal, countVal)
  return self:invokeApi("fave.getLinks", {offset=offsetVal, count=countVal})
end

function LuaVkApi:bookmarkUser(userId)
  return self:invokeApi("fave.addUser", {user_id=userId})
end

function LuaVkApi:removeBookmarkedUser(userId)
  return self:invokeApi("fave.removeUser", {user_id=userId})
end

function LuaVkApi:bookmarkGroup(groupId)
  return self:invokeApi("fave.addGroup", {group_id=groupId})
end

function LuaVkApi:removeBookmarkedGroup(groupId)
  return self:invokeApi("fave.removeGroup", {group_id=groupId})
end

function LuaVkApi:bookmarkLink(linkStr, textStr)
  return self:invokeApi("fave.addLink", {link=linkStr, text=textStr})
end

function LuaVkApi:removeBookmarkedLink(linkId)
  return self:invokeApi("fave.removeLink", {link_id=linkId})
end

function LuaVkApi:getLikedMarketItems(countVal, offsetVal, isExtended)
  return self:invokeApi("fave.getMarketItems", {offset=offsetVal, count=countVal,
      extended=isExtended})
end

-----------------------
--   Notifications   --
-----------------------
function LuaVkApi:getNotifications(countVal, startFrom, filtersVal, startTime, endTime)
  return self:invokeApi("notifications.get", {count=countVal, start_from=startFrom,
      filters=filtersVal, start_time=startTime, end_time=endTime})
end

function LuaVkApi:markNotificationsAsViewed()
  return self:invokeApi("notifications.markAsViewed")
end

-----------------------
--       Stats       --
-----------------------
function LuaVkApi:getStatistics(groupId, appId, dateFrom, dateTo)
  return self:invokeApi("stats.get", {group_id=groupId, app_id=appId, date_from=dateFrom,
      date_to=dateTo})
end

function LuaVkApi:trackVisitor()
  return self:invokeApi("stats.trackVisitor")
end

function LuaVkApi:trackVisitor(ownerId, postId)
  return self:invokeApi("stats.getPostReach", {owner_id=ownerId, post_id=postId})
end

-----------------------
--      Search       --
-----------------------
function LuaVkApi:getHint(query, limitVal, filtersVal, searchGlobal)
  return self:invokeApi("search.getHints", {q=query, limit=limitVal, filters=filtersVal,
      search_global=searchGlobal})
end

-----------------------
--       Apps        --
-----------------------
function LuaVkApi:getAppsCatalog(sortVal, offsetVal, countVal, platformVal, isExtended,
    returnFriends, fieldsVal, nameCase, query, genreId, filterVal)
  return self:invokeApi("apps.getCatalog", {sort=sortVal, offset=offsetVal, count=countVal,
      platform=platformVal, extended=isExtended, return_friends=returnFriends, fields=fieldsVal, 
      name_case=nameCase, q=query, genre_id=genreId, filter=filterVal})
end

function LuaVkApi:getApp(appId, appIds, platformVal, isExtended, returnFriends, fieldsVal,
    nameCase)
  return self:invokeApi("apps.get", {app_id=appId, app_ids=appIds, platform=platformVal,
      extended=isExtended, return_friends=returnFriends, fields=fieldsVal, name_case=nameCase})
end

function LuaVkApi:sendAppRequest(userId, textVal, typeVal, nameVal, keyVal, separateVal)
  return self:invokeApi("apps.sendRequest", {user_id=userId, text=textVal, type=typeVal,
  	name=nameVal, key=keyVal, separate=separateVal})
end

function LuaVkApi:deleteAppRequests()
  return self:invokeApi("apps.deleteAppRequests")
end

function LuaVkApi:getFriendsList(isExtended, countVal, offsetVal, typeVal, fieldsVal)
  return self:invokeApi("apps.getFriendsList", {extended=isExtended, count=countVal, 
      offset=offsetVal, type=typeVal, fields=fieldsVal})
end

function LuaVkApi:getLeaderboard(typeVal, globalVal, isExtended)
  return self:invokeApi("apps.getLeaderboard", {type=typeVal, global=globalVal, 
      extended=isExtended})
end

function LuaVkApi:getScore(userId)
  return self:invokeApi("apps.getScore", {user_id=userId})
end

-----------------------
--     Service       --
-----------------------
function LuaVkApi:checkLink(urlStr)
  return self:invokeApi("utils.checkLink", {url=urlStr})
end

function LuaVkApi:resolveScreenName(screenNsme)
  return self:invokeApi("utils.resolveScreenName", {screen_name=screenNsme})
end

function LuaVkApi:getServerTime()
  return self:invokeApi("utils.getServerTime")
end

-----------------------
--     VK data       --
-----------------------
function LuaVkApi:getCountries(needAll, codeStr, offsetVal, countVal)
  return self:invokeApi("database.getCountries", {need_all=needAll, code=codeStr,
      offset=offsetVal, count=countVal})
end

function LuaVkApi:getRegions(countryId, query, offsetVal, countVal)
  return self:invokeApi("database.getRegions", {country_id=countryId, q=query,
      offset=offsetVal, count=countVal})
end

function LuaVkApi:getStreetsById(streetIds)
  return self:invokeApi("database.getStreetsById", {street_ids=streetIds})
end

function LuaVkApi:getCountriesById(countryIds)
  return self:invokeApi("database.getCountriesById", {country_ids=countryIds})
end

function LuaVkApi:getCities(countryId, regionId, query, needAll, offsetVal, countVal)
  return self:invokeApi("database.getCities", {country_id=countryId, region_id=regionId,
      q=query, need_all=needAll, offset=offsetVal, count=countVal})
end

function LuaVkApi:getCitiesById(cityIds)
  return self:invokeApi("database.getCitiesById", {city_ids=cityIds})
end

function LuaVkApi:getUniversities(query, countryId, cityId, offsetVal, countVal)
  return self:invokeApi("database.getUniversities", {q=query, country_id=countryId, 
      city_id=cityId, offset=offsetVal, count=countVal})
end

function LuaVkApi:getSchools(query, cityId, offsetVal, countVal)
  return self:invokeApi("database.getSchools", {q=query, city_id=cityId, offset=offsetVal,
      count=countVal})
end

function LuaVkApi:getSchoolClasses(countryId)
  return self:invokeApi("database.getSchoolClasses", {country_id=countryId})
end

function LuaVkApi:getFaculties(universityId, offsetVal, countVal)
  return self:invokeApi("database.getFaculties", {university_id=universityId, offset=offsetVal,
      count=countVal})
end

function LuaVkApi:getChairs(facultyId, offsetVal, countVal)
  return self:invokeApi("database.getChairs", {faculty_id=facultyId, offset=offsetVal,
      count=countVal})
end

-----------------------
--      Gifts        --
-----------------------
function LuaVkApi:getGifts(userId, countVal, offsetVal)
  return self:invokeApi("gifts.get", {user_id=userId, count=countVal, offset=offsetVal})
end

-----------------------
--      Leads        --
-----------------------
function LuaVkApi:completeLead(vkSid, secretVal, commentVal)
  return self:invokeApi("leads.complete", {vk_sid=vkSid, secret=secretVal, comment=commentVal})
end

function LuaVkApi:startLead(leadId, secretVal, aId, uId, testMode, isForce)
  return self:invokeApi("leads.start", {lead_id=leadId, secret=secretVal, aid=aId,
  	uid=uId, test_mode=testMode, force=isForce})
end

function LuaVkApi:getLeadStats(leadId, secretVal, dateStart, dateEnd)
  return self:invokeApi("leads.getStats", {lead_id=leadId, secret=secretVal, date_start=dateStart,
  	date_end=dateEnd})
end

function LuaVkApi:getLeadUsers(offerId, secretVal, offsetVal, countVal, statusVal, isReverse)
  return self:invokeApi("leads.getUsers", {offer_id=offerId, secret=secretVal, offset=offsetVal,
  	count=countVal, status=statusVal, reverse=isReverse})
end

function LuaVkApi:checkLeadUser(leadId, testResult, testMode, autoStart, ageVal, countryVal)
  return self:invokeApi("leads.getUsers", {lead_id=leadId, test_result=testResult, test_mode=testMode,
  	auto_start=autoStart, age=ageVal, country=countryVal})
end

function LuaVkApi:metricHit(dataVala)
  return self:invokeApi("leads.metricHit", {data=dataVala})
end

-----------------------
--      Market       --
-----------------------
function LuaVkApi:getMarketItems(ownerId, albumId, countVal, offsetVal, isExtended)
  return self:invokeApi("market.get", {owner_id=ownerId, album_id=albumId, count=countVal,
      offset=offsetVal, extended=isExtended})
end

function LuaVkApi:getMarketItemsById(itemIds, isExtended)
  return self:invokeApi("market.getById", {item_ids=itemIds, extended=isExtended})
end

function LuaVkApi:searchMarketItems(ownerId, albumId, query, priceFrom, priceTo, tagsVal,
    sortVal, revVal, offsetVal, countVal, isExtended)
  return self:invokeApi("market.search", {owner_id=ownerId, album_id=albumId, 
      q=query, price_from=priceFrom, price_to=priceTo, tags=tagsVal, sort=sortVal,
	  rev=revVal, offset=offsetVal, count=countVal, extended=isExtended})
end

function LuaVkApi:getMarketAlbums(ownerId, offsetVal, countVal)
  return self:invokeApi("market.getAlbums", {owner_id=ownerId, offset=offsetVal,
      count=countVal})
end

function LuaVkApi:getMarketAlbumsById(ownerId, albumIds)
  return self:invokeApi("market.getAlbumById", {owner_id=ownerId, album_ids=albumIds})
end

function LuaVkApi:createMarketComment(ownerId, itemId, messageVal, attachmentsVal,
    fromGroup, replyToComment, stickerId, guId)
  return self:invokeApi("market.createComment", {owner_id=ownerId, item_id=itemId,
      message=messageVal, attachments=attachmentsVal, from_group=fromGroup,
	  reply_to_comment=replyToComment, sticker_id=stickerId, guid=guId})
end

function LuaVkApi:getMarketComments(ownerId, itemId, needLikes, startCommentId,
    offsetVal, countVal, sortVal, isExtended, fieldsVal)
  return self:invokeApi("market.getComments", {owner_id=ownerId, item_id=itemId,
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal,
	  count=countVal, sort=sortVal, extended=isExtended, fields=fieldsVal})
end

function LuaVkApi:deleteMarketComment(ownerId, commentId)
  return self:invokeApi("market.deleteComment", {owner_id=ownerId, 
      comment_id=commentId})
end

function LuaVkApi:restoreMarketComment(ownerId, commentId)
  return self:invokeApi("market.restoreComment", {owner_id=ownerId, 
      comment_id=commentId})
end

function LuaVkApi:editMarketComment(ownerId, commentId, messageVal, attachmentsVal)
  return self:invokeApi("market.editComment", {owner_id=ownerId, 
      comment_id=commentId, message=messageVal, attachments=attachmentsVal})
end

function LuaVkApi:reportMarketComment(ownerId, commentId, reasonVal)
  return self:invokeApi("market.reportComment", {owner_id=ownerId, 
      comment_id=commentId, reason=reasonVal})
end

function LuaVkApi:getMarketCategories(countVal, offsetVal)
  return self:invokeApi("market.getCategories", {count=countVal, offset=offsetVal})
end

function LuaVkApi:reportMarketItem(ownerId, itemId, reasonVal)
  return self:invokeApi("market.report", {owner_id=ownerId, item_id=itemId,
      reason=reasonVal})
end

function LuaVkApi:addMarketItem(ownerId, nameVal, descriptionVal, categoryId,
    priceVal, isDeleted, mainPhotoId, photoIds)
  return self:invokeApi("market.add", {owner_id=ownerId, name=nameVal,
      description=descriptionVal, category_id=categoryId, price=priceVal,
	  deleted=isDeleted, main_photo_id=mainPhotoId, photo_ids=photoIds})
end

function LuaVkApi:editMarketItem(ownerId, itemId, nameVal, descriptionVal, categoryId,
    priceVal, isDeleted, mainPhotoId, photoIds)
  return self:invokeApi("market.edit", {owner_id=ownerId, item_id=itemId, 
	  name=nameVal, description=descriptionVal, category_id=categoryId, price=priceVal,
	  deleted=isDeleted, main_photo_id=mainPhotoId, photo_ids=photoIds})
end

function LuaVkApi:deleteMarketItem(ownerId, itemId)
  return self:invokeApi("market.delete", {owner_id=ownerId, item_id=itemId})
end

function LuaVkApi:restoreMarketItem(ownerId, itemId)
  return self:invokeApi("market.restore", {owner_id=ownerId, item_id=itemId})
end

function LuaVkApi:reorderMarketItems(ownerId, albumId, itemId, beforeVal, afterVal)
  return self:invokeApi("market.reorderItems", {owner_id=ownerId, album_id=albumId,
      item_id=itemId, before=beforeVal, after=afterVal})
end

function LuaVkApi:reorderMarketAlbums(ownerId, albumId, beforeVal, afterVal)
  return self:invokeApi("market.reorderAlbums", {owner_id=ownerId, album_id=albumId,
      before=beforeVal, after=afterVal})
end

function LuaVkApi:addMarketAlbum(ownerId, titleVal, photoId, mainAlbum)
  return self:invokeApi("market.addAlbum", {owner_id=ownerId, title=titleVal,
      photo_id=photoId, main_album=mainAlbum})
end

function LuaVkApi:editMarketAlbum(ownerId, albumId, titleVal, photoId, mainAlbum)
  return self:invokeApi("market.editAlbum", {owner_id=ownerId, album_id=albumId,
      title=titleVal, photo_id=photoId, main_album=mainAlbum})
end

function LuaVkApi:deleteMarketAlbum(ownerId, albumId)
  return self:invokeApi("market.deleteAlbum", {owner_id=ownerId, album_id=albumId})
end

function LuaVkApi:removeFromMarketAlbum(ownerId, itemId, albumIds)
  return self:invokeApi("market.removeFromAlbum", {owner_id=ownerId, item_id=itemId,
      album_ids=albumIds})
end

function LuaVkApi:addToMarketAlbum(ownerId, itemId, albumIds)
  return self:invokeApi("market.addToAlbum", {owner_id=ownerId, item_id=itemId,
      album_ids=albumIds})
end

-----------------------
--      Other        --
-----------------------
function LuaVkApi:executeCode(codeStr)
  return self:invokeApi("execute", {code=codeStr})
end






--[[
function LuaVkApi:getStatus(userId, groupId)
  return self:invokeApi("status.get", {user_id=userId, group_id=groupId})
end
]]


return LuaVkApi
