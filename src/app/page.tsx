import { createServerComponentClient } from '@supabase/auth-helpers-nextjs'
import AuthButtonServer from '@/components/AuthButtonServer'
import { cookies } from 'next/headers'
import { redirect } from 'next/navigation'

export default async function Home() {
  const supabase = createServerComponentClient<Database>({ cookies })
  const {
    data: { session }
  } = await supabase.auth.getSession()

  if (!session) {
    redirect('/login')
  }

  const { data: tweets } = await supabase
    .from('tweets')
    .select('*, profiles(*)')
  return (
    <>
      <AuthButtonServer />
      <pre>{JSON.stringify(tweets, null, 2)}</pre>
    </>
  )
}
