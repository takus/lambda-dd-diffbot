import os
import json
import boto3
import urllib
import urllib2
import time
import datetime

instance = {
    'datadog_api_endpoint': "https://app.datadoghq.com/api/v1/series",
    'datadog_api_key': os.environ.get('DATADOG_API_KEY', 'dummy'),
    'diffbot_api_endpoint': "http://api.diffbot.com/v3/account",
    'diffbot_token': os.environ.get('DIFFBOT_TOKEN', 'dummy'),
}

class Stats(object):

    def __init__(self):
        self.series = []

    def gauge(self, metric, value, timestamp=None, tags=None, host=None):
        base_dict = {
            'metric': metric,
            'points': [(int(timestamp or time.time()), value)],
            'type': 'gauge',
            'tags': tags,
        }
        if host:
            base_dict.update({'host': host})
        self.series.append(base_dict)

    def flush(self):
        metrics_dict = {
            'series': self.series,
        }
        self.series = []

        req = urllib2.Request(
                '%s?api_key=%s' % (instance['datadog_api_endpoint'], instance['datadog_api_key']),
                json.dumps(metrics_dict),
                {'Content-Type': 'application/json'})
        res = urllib2.urlopen(req)
        print 'INFO Submitted data with status', res.getcode()

stats = Stats()

def lambda_handler(event, context):
    today = datetime.date.today()
    first_date_of_this_month = datetime.date(day=1, month=today.month, year=today.year)

    req = urllib2.Request('%s?token=%s' % (instance['diffbot_api_endpoint'], instance['diffbot_token']))
    res = urllib2.urlopen(req)
    m = json.loads(res.read())

    monthly_calls = 0
    monthly_proxy_calls = 0
    for c in m['apiCalls']:
        d = c['date'].split('-')
        if datetime.date(int(d[0]), int(d[1]), int(d[2])) < first_date_of_this_month:
            continue
        monthly_calls += c['calls']
        monthly_proxy_calls += c['proxyCalls']

    stats.gauge("diffbot.monthlyCalls", monthly_calls)
    stats.gauge("diffbot.monthlyProxyCalls", monthly_proxy_calls)
    stats.gauge("diffbot.monthlyPlanCalls", m['planCalls'])

    stats.flush()
    return {'Status': 'OK'}
