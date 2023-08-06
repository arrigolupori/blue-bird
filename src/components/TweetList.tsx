'use client'

import { createClientComponentClient } from '@supabase/auth-helpers-nextjs'
import LikeButton from './LikeButton'
import { useEffect, experimental_useOptimistic as useOptimistic } from 'react'
import { useRouter } from 'next/navigation'

export default function TweetList({ tweets }: { tweets: TweetWithAuthor[] }) {
  const [optimisticTweets, addOptimisticTweet] = useOptimistic<
    TweetWithAuthor[],
    TweetWithAuthor
  >(tweets, (currentOptimisticTweets, newTweet) => {
    const newOptimisticTweets = [...currentOptimisticTweets]
    const index = newOptimisticTweets.findIndex(
      (tweet) => tweet.id === newTweet.id
    )
    newOptimisticTweets[index] = newTweet
    return newOptimisticTweets
  })

  const supabase = createClientComponentClient<Database>()
  const router = useRouter()

  useEffect(() => {
    const channel = supabase
      .channel('realtime tweets')
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'tweets'
        },
        (payload) => {
          router.refresh()
        }
      )
      .subscribe()

    return () => {
      supabase.removeChannel(channel)
    }
  }, [router, supabase])

  return optimisticTweets.map((tweet) => (
    <div key={tweet.id}>
      <p>
        {tweet.author.name} {tweet.author.username}
      </p>
      <p>{tweet.title}</p>
      <LikeButton
        tweet={tweet as any}
        addOptimisticTweet={addOptimisticTweet}
      />
    </div>
  ))
}
