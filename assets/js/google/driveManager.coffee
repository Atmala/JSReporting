define  ['settings/googleDriveSettings'], (GoogleDriveSettings) ->

  class DriveManager

    FormatEnum: {
      binary : 0,
      csv : 1
    }

    authenticate: (callback) ->
      doAuth((res) ->
        console.log('Auth response:', res)
        loadDrive(callback)
      )

    getReportByFileId: (fileId, format, callback) ->
      getFileMetaDataById(fileId, 'exportLinks', (rs) ->
        url = rs.exportLinks['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
        console.log('Excel link is: ', url)
        getFileContent(url, format, callback)
      )

    getReportByFileName: (fileName, format, callback) ->
      getFileMetaDataByName(fileName, (rs) ->
        url = rs.exportLinks['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
        console.log('Excel link is: ', url)
        getFileContent(url, format, callback)
      )

    getFileList: (querry, responseHandler) ->
      gapi.client.request({
      'path': '/drive/v2/files',
      'method': 'GET',
      'params': {'q': querry}
      }).execute(responseHandler)

    ########################
    #   Private functions  #
    ########################

    getFileContent = (url, format, callback) ->
      switch format
        when reportApp.GoogleDriveHelper.FormatEnum.binary then getFileBinaryContent(url, callback)
        when reportApp.GoogleDriveHelper.FormatEnum.csv then getFileCsvContent(url, callback)


    loadDrive = (callback) ->
      gapi.client.load('drive', 'v2', () ->  callback())

    getFileMetaDataById = (fileId, fields, callback) ->
      gapi.client.drive.files.get({'fileId':fileId,
      'fields': fields}).execute((r) ->
        console.log('Requesting file meta data for \'', fileId, '\'         Response:', r)
        callback(r))

    getFileMetaDataByName = (fileName, callback) ->
      gapi.client.drive.files.list({'q':'title contains \''+fileName+'\''}).execute((r) ->
        console.log('Requesting file meta data for \'', fileName, '\'         Response:', r)
        #TODO trow exception if file not found
        callback(r.items[0])
      )

    getFileBinaryContent = (url, callback) ->
      xhr = new XMLHttpRequest();
      xhr.open('GET', url, true);
      xhr.responseType = "arraybuffer";
      xhr.setRequestHeader('Authorization', 'Bearer ' + gapi.auth.getToken().access_token );
      xhr.onload = (e) ->
        base64Data = base64ArrayBuffer(e.currentTarget.response)
        callback(base64Data)

      xhr.send(null);

    #NOTE: csv response will contain only the first page
    getFileCsvContent = (url, callback) ->
      url = url.replace('=xlsx', '=csv')
      $.ajax({
      url:  url,
      beforeSend:  ( xhr ) ->
        xhr.overrideMimeType("text/plain; charset=utf-8")
        xhr.setRequestHeader('Authorization', 'Bearer ' + gapi.auth.getToken().access_token )
      }).done(( data ) ->
        callback(data)
      )

    doAuth = (callback) ->
      gapi.auth.authorize({'client_id': GoogleDriveSettings.CLIENT_ID,
      'scope': GoogleDriveSettings.SCOPES,
      'immediate': false},
      callback
      )


