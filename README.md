# Lone Arranger plugin

Creates a Lone Arranger group that is (automatically) added to new
and existing repositories created in ArchivesSpace.

On startup:

- The Lone Arranger group permissions are reset (enforced)
- Repository users are assigned exclusively to the Lone Arranger group

The group permissions are defined here:

- [Lone Arranger permissions](https://lyrasis-my.sharepoint.com/:x:/g/personal/tang_lyrasis_org/ETDVwkHC8TlMj4JfUCCkH0MBEZo5cJea0ZSvdZ4IkVoe-w?e=DOaVvN)

**Warning: this plugin should never be used for any instance that
does not want all users to be assigned to a single Lone Arranger
group per repository.**

To view LAG permissions:

```sql
SELECT
  g.id,
  g.group_code,
  p.permission_code
FROM group_permission gp
JOIN `group` g ON gp.group_id = g.id
JOIN permission p ON gp.permission_id = p.id
WHERE g.group_code = 'lone-arranger'
ORDER BY g.id, p.permission_code
;
```
