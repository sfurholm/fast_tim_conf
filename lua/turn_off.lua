crypt = require('crypt')
local currentIdx = os.time()/60/60/24 - 15000

function memc_set(key, val)
  local resp = ngx.location.capture('/cache',
    { method = ngx.HTTP_POST,
      body = val,
      args = { key = key:lower() } 
    }
  )

  return resp.body, resp.status
end

function memc_get(key)
  local resp = ngx.location.capture('/cache',
    { method = ngx.HTTP_GET,
      body = '',
      args = { key = key:lower() } 
    }
  )

  return resp.body, resp.status
end

function memc_delete(key)
  local resp = ngx.location.capture('/cache',
    { method = ngx.HTTP_DELETE,
      body = '',
      args = { key = key:lower() } 
    }
  )

  return resp.body, resp.status
end

function memc_update(key, val)
  local resp = ngx.location.capture('/cache',
    { method = ngx.HTTP_PUT,
      body = val,
      args = { key = key:lower() } 
    }
  )

  return resp.body, resp.status
end


local args = ngx.req.get_uri_args() 
local acr, status = memc_get(("tid_%s"):format(args.tid))

local new_tid = "OPT-OUT"
memc_update(("acr_%s"):format(acr), new_tid)
memc_delete(("tid_%s"):format(args.tid))

ngx.say("acr: ", acr)
ngx.say("tid: ", args.tid)
ngx.say("new tid", new_tid)
