# API Rate Limiting

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide to API rate limiting for Agent Factory Platform

---

## Overview

**Rate Limiting** protects the Agent Factory API from abuse and ensures fair usage across all customers. This document explains rate limits, how they work, and how to handle them.

---

## Rate Limit Tiers

### Starter Tier

**Rate Limits:**
- **API Calls:** 1,000 requests/hour
- **Concurrent Requests:** 10
- **Burst:** 50 requests/minute

**Use Case:** Development, testing, small applications

---

### Pro Tier

**Rate Limits:**
- **API Calls:** 10,000 requests/hour
- **Concurrent Requests:** 50
- **Burst:** 200 requests/minute

**Use Case:** Production applications, moderate traffic

---

### Enterprise Tier

**Rate Limits:**
- **API Calls:** Custom (100,000+ requests/hour)
- **Concurrent Requests:** Custom (500+)
- **Burst:** Custom (1,000+ requests/minute)

**Use Case:** High-traffic applications, enterprise needs

---

## Rate Limit Headers

### Response Headers

**Every API response includes:**

```
X-RateLimit-Limit: 10000
X-RateLimit-Remaining: 9995
X-RateLimit-Reset: 1642248000
```

**Header Descriptions:**
- `X-RateLimit-Limit`: Total requests allowed per hour
- `X-RateLimit-Remaining`: Remaining requests in current window
- `X-RateLimit-Reset`: Unix timestamp when limit resets

---

## Rate Limit Responses

### Success Response

**Status:** `200 OK`

**Headers:**
```
X-RateLimit-Limit: 10000
X-RateLimit-Remaining: 9995
X-RateLimit-Reset: 1642248000
```

---

### Rate Limit Exceeded

**Status:** `429 Too Many Requests`

**Headers:**
```
X-RateLimit-Limit: 10000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1642248000
Retry-After: 3600
```

**Response Body:**
```json
{
  "error": {
    "code": "rate_limit_exceeded",
    "message": "Rate limit exceeded. Please retry after 1642248000",
    "retry_after": 3600
  }
}
```

---

## Handling Rate Limits

### Best Practices

**1. Monitor Rate Limit Headers:**
- Check `X-RateLimit-Remaining`
- Implement alerts when low
- Adjust request rate accordingly

**2. Implement Exponential Backoff:**
- Retry with increasing delays
- Use `Retry-After` header
- Respect rate limit reset time

**3. Use Caching:**
- Cache responses when possible
- Reduce API calls
- Improve performance

**4. Batch Requests:**
- Combine multiple requests
- Use batch endpoints
- Reduce request count

---

### Exponential Backoff Example

**Python:**
```python
import time
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

def make_request_with_retry(url, headers, max_retries=3):
    session = requests.Session()
    retry_strategy = Retry(
        total=max_retries,
        backoff_factor=1,
        status_forcelist=[429],
        respect_retry_after_header=True
    )
    adapter = HTTPAdapter(max_retries=retry_strategy)
    session.mount("http://", adapter)
    session.mount("https://", adapter)
    
    response = session.get(url, headers=headers)
    return response
```

**JavaScript:**
```javascript
async function makeRequestWithRetry(url, headers, maxRetries = 3) {
  let retries = 0;
  let delay = 1000; // Start with 1 second
  
  while (retries < maxRetries) {
    try {
      const response = await fetch(url, { headers });
      
      if (response.status === 429) {
        const retryAfter = response.headers.get('Retry-After');
        const waitTime = retryAfter ? parseInt(retryAfter) * 1000 : delay;
        
        await new Promise(resolve => setTimeout(resolve, waitTime));
        delay *= 2; // Exponential backoff
        retries++;
        continue;
      }
      
      return response;
    } catch (error) {
      if (retries === maxRetries - 1) throw error;
      await new Promise(resolve => setTimeout(resolve, delay));
      delay *= 2;
      retries++;
    }
  }
}
```

---

## Rate Limit Monitoring

### Track Usage

**Monitor Headers:**
- Track `X-RateLimit-Remaining`
- Alert when below threshold
- Log rate limit events

**Example:**
```python
def track_rate_limit(response):
    remaining = int(response.headers.get('X-RateLimit-Remaining', 0))
    limit = int(response.headers.get('X-RateLimit-Limit', 0))
    
    usage_percent = (1 - remaining / limit) * 100
    
    if usage_percent > 80:
        send_alert(f"Rate limit usage: {usage_percent}%")
    
    return remaining, limit
```

---

## Rate Limit Strategies

### Strategy 1: Request Throttling

**Implement client-side throttling:**
- Limit request rate
- Queue requests
- Smooth out traffic

**Example:**
```python
from time import sleep
from collections import deque

class RateLimiter:
    def __init__(self, max_requests, time_window):
        self.max_requests = max_requests
        self.time_window = time_window
        self.requests = deque()
    
    def wait_if_needed(self):
        now = time.time()
        # Remove old requests
        while self.requests and self.requests[0] < now - self.time_window:
            self.requests.popleft()
        
        # Wait if at limit
        if len(self.requests) >= self.max_requests:
            sleep_time = self.time_window - (now - self.requests[0])
            sleep(sleep_time)
        
        self.requests.append(now)
```

---

### Strategy 2: Caching

**Cache responses:**
- Reduce API calls
- Improve performance
- Stay within limits

**Example:**
```python
from functools import lru_cache
from datetime import datetime, timedelta

cache_ttl = timedelta(minutes=5)

@lru_cache(maxsize=100)
def get_cached_data(key, timestamp):
    # Cache key includes timestamp for TTL
    return fetch_from_api(key)

def get_data(key):
    now = datetime.now()
    cache_key = (key, now.replace(second=0, microsecond=0))
    return get_cached_data(cache_key[0], cache_key[1])
```

---

### Strategy 3: Request Batching

**Batch multiple requests:**
- Combine requests
- Reduce API calls
- Improve efficiency

**Example:**
```python
class RequestBatcher:
    def __init__(self, batch_size=10, batch_timeout=1.0):
        self.batch_size = batch_size
        self.batch_timeout = batch_timeout
        self.batch = []
        self.last_batch_time = time.time()
    
    def add_request(self, request):
        self.batch.append(request)
        
        if len(self.batch) >= self.batch_size:
            return self.flush()
        
        if time.time() - self.last_batch_time > self.batch_timeout:
            return self.flush()
        
        return None
    
    def flush(self):
        if not self.batch:
            return None
        
        batch = self.batch.copy()
        self.batch.clear()
        self.last_batch_time = time.time()
        
        return batch_api_requests(batch)
```

---

## Rate Limit Errors

### Handling 429 Errors

**1. Check Headers:**
- Read `Retry-After` header
- Read `X-RateLimit-Reset` header
- Calculate wait time

**2. Implement Backoff:**
- Use exponential backoff
- Respect `Retry-After` header
- Don't retry immediately

**3. Log and Monitor:**
- Log rate limit events
- Monitor frequency
- Alert if frequent

---

## Best Practices

### Do's

✅ **Monitor rate limit headers**  
✅ **Implement exponential backoff**  
✅ **Use caching when possible**  
✅ **Batch requests when possible**  
✅ **Respect `Retry-After` header**  
✅ **Log rate limit events**

---

### Don'ts

❌ **Don't ignore rate limit headers**  
❌ **Don't retry immediately on 429**  
❌ **Don't make unnecessary requests**  
❌ **Don't exceed burst limits**  
❌ **Don't ignore rate limit errors**

---

## Upgrading Limits

### When to Upgrade

**Consider upgrading if:**
- Frequently hitting rate limits
- Need higher concurrent requests
- Require custom limits
- Enterprise needs

**Upgrade Process:**
1. Contact sales
2. Discuss requirements
3. Upgrade plan
4. New limits activated

---

## Support

### Resources

**Documentation:**
- API Reference: https://docs.agentfactory.com/api
- Rate Limiting Guide: https://docs.agentfactory.com/api/rate-limiting

**Support:**
- Email: support@agentfactory.com
- Enterprise: enterprise@agentfactory.com

---

**Remember:** Rate limiting protects the API and ensures fair usage. Implement proper handling to avoid disruptions and optimize your API usage.
