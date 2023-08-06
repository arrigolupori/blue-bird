import type { Database as DB } from '../../supabase/db.types'

declare global {
  type Database = DB
}
