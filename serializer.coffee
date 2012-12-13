# -*- coding: utf-8 -*-

SCOPE._SERIALIZERS =
    "json": yes
    "yaml": no

class SCOPE.BaseSerializer
    ### Base class ###
    #
    #

    key: no

    content_types: no

    get_content_type: () ->
        if @content_types is no
            console.log "NotImplementedError"
        @content_types[0]

    loads: (data) ->
        console.log "NotImplementedError"

    dumps: (data) ->
        console.log "NotImplementedError"


class SCOPE.JsonSerializer extends SCOPE.BaseSerializer
    ### For json ###
    #
    #

    key: "json"

    content_types: [
        "application/json"
        "application/x-javascript"
        "text/javascript"
        "text/x-javascript"
        "text/x-json"
    ]

    loads: (data) ->
        JSON.parse(data)

    dumps: (data) ->
        JSON.stringify(data)


class SCOPE.YamlSerializer extends SCOPE.BaseSerializer
    ### For yaml ###

    key: "yaml"

    content_types: ["text/yaml"]

    loads: (data) ->
        yaml.safe_load(data)

    dumps: (data) ->
        yaml.dump(data)

# Any format
#
#
#
#
#

class SCOPE.Serializer
    ### Execute class ###
    #
    #
    constructor: (default_format=no, serializers=no) ->
        ### Set Serializer ###
        #
        #
        if default_format is no
            default_format = if SCOPE._SERIALIZERS["json"] then "json" else "yaml"

        if serializers is no
            serializers = (x for x in [new SCOPE.JsonSerializer, new SCOPE.YamlSerializer] when SCOPE._SERIALIZERS[x.key])

        if not serializers
            console.log "There are no Available Serializers."

        @serializers = {}

        for serializer in serializers
            @serializers[serializer.key] = serializer

        @default_format = default_format

    get_serializer: (name=no, content_type=no) ->
        ### Get serializer ###
        #
        # InitializeでセットしたSerializerを取得
        #
        #
        if name is no and content_type is no
            # name, content_typeに値がない場合はdefault_formatを使用
            @serializers[@default_format]
        else if name is not no and content_type is no
            # nameで取得　
            if not name in @serializers
                console.log "#{name} is not an available serializer"
            @serializers[name]
        else
            # content_typeで取得　
            for k, serializer_obj of @serializers
                for ctype in serializer_obj.content_types
                    if content_type == ctype
                        return serializer_obj
            console.log "#{content_type} is not an available serializer"

    dumps: (data, format=no) ->
        ### Serialize ###
        #
        #
        s = @get_serializer(format)
        s.dumps(data)

    loads: (data, format=no) ->
        ### Unserialize ###
        #
        #
        s = @get_serializer(format)
        s.loads(data)

    get_content_type: (format=no) ->
        ### Get format content type ###
        #
        #
        s = @get_serializer(format)
        s.get_content_type()
