#!/bin/bash

watch '(/opt/vc/bin/vcgencmd measure_temp; \
		/opt/vc/bin/vcgencmd measure_clock arm)'
