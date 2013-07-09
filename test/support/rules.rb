

# The default for tar is to try and use the user from the tar file when run as the
# superuser, as Chef is. This is not the default for non-superusers and is a common
# mistake. This results in directories owned by an unknown user. Require
# that the tar command be explicit about the behavior.
rule 'MZS001', 'Tar command run as root without explicit ownership' do
  tags %w{style recipe mzs}
  recipe do |ast|
    find_resources(ast).select do |res|
      if %w{execute bash}.include?(resource_type(res))
        cmd_str = (resource_attribute(res, 'command') || resource_attribute(res, 'code') || resource_name(res)).to_s
        if match_data = cmd_str.match(/tar ([^\|$]+)/)
          args = match_data[1]
          perms_set = false
          %w{--same-owner --no-same-owner}.each do |arg_name|
            perms_set ||= args.include?(arg_name)
          end
          !perms_set
        else
          false
        end
      end
    end

  end
end
