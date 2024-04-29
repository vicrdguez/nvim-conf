local M = {}

function M.relative_path(filenames, dir)
  local cmd = 'realpath --relative-to ' .. dir

  if type(filenames) == table then
    for filename in pairs(filenames) do
      cmd = cmd .. ' ' .. filename
    end
  else
    cmd = cmd .. ' ' .. filenames
  end

  local result = vim.fn.systemlist(cmd)
  if result ~= nil then
    if #result > 1 then
      return result
    end
    return result[1]
  end
  return nil
end

function M.relative_to_current_file(filenames)
  return M.relative_path(filenames, vim.fn.expand('%:h'))
end

--- Creates a folder if it does not exsist. It assumes happy path now and does not check on any
--- errors like creating a folder in a read only fs.
---
---@param dir string the directory to create
---@return string|boolean mkdir_out created directory or false if it already existed
function M.maybe_mkdir(dir)
  local output = vim.fn.system('ls ' .. dir)
  if string.find(output, 'No such file') then
    local mkdir_out = vim.fn.system('mkdir -v ' .. dir)
    if string.find(mkdir_out, 'File exists') then
      return dir
    else
      return mkdir_out
    end
  end
  return true
end

return M
