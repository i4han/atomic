(function($, window, document, undefined) {
	$(document).ready( function() {
        var randNum = function (){
            return ((Math.floor( Math.random()* (1+40-20) ) ) + 20)* 1200;
        }
    
        var randNum2 = function (){
            return ((Math.floor( Math.random()* (1+40-20) ) ) + 20) * 500;
        }
    
        var randNum3 = function (){
            return ((Math.floor( Math.random()* (1+40-20) ) ) + 20) * 300;
        }
    
        var randNum4 = function (){
            return ((Math.floor( Math.random()* (1+40-20) ) ) + 20) * 100;
        }

         // we use an inline data source in the example, usually data would
        // be fetched from a server
        var data = [], totalPoints = 300;
        var getRandomData = function () {
            if (data.length > 0)
                data = data.slice(1);

            // do a random walk
            while (data.length < totalPoints) {
                var prev = data.length > 0 ? data[data.length - 1] : 50;
                var y = prev + Math.random() * 10 - 5;
                if (y < 0)
                    y = 0;
                if (y > 100)
                    y = 100;
                data.push(y);
            }

            // zip the generated y values with the x values
            var res = [];
            for (var i = 0; i < data.length; ++i)
                res.push([i, data[i]])
            return res;
        }

        // setup control widget
        var updateInterval = 100;

        if($("#realtimechart").length)
        {
            var options = {
                series: { shadowSize: 1 },
                lines: { fill: true, fillColor: { colors: [ { opacity: 1 }, { opacity: 0.1 } ] }},
                yaxis: { min: 0, max: 100 },
                xaxis: { show: false },
                colors: ["#F4A506"],
                grid: { tickColor: "#dddddd",
                        borderWidth: 0
                },
            };
            var plot = $.plot($("#realtimechart"), [ getRandomData() ], options);
            function update() {
                plot.setData([ getRandomData() ]);
                // since the axes don't change, we don't need to call plot.setupGrid()
                plot.draw();

                setTimeout(update, updateInterval);
            }

            update();
        }

        if($("#realtimechart2").length)
        {
            var options2 = {
                series: { shadowSize: 1 },
                lines: { fill: true, fillColor: { colors: [ { opacity: 1 }, { opacity: 0.1 } ] }},
                yaxis: { min: 0, max: 100 },
                xaxis: { show: false },
                colors: ["#F4A506"],
                grid: { tickColor: "#dddddd",
                        borderWidth: 0
                },
            };
            var plot2 = $.plot($("#realtimechart2"), [ getRandomData() ], options2);
            function update2() {
                plot2.setData([ getRandomData() ]);
                // since the axes don't change, we don't need to call plot.setupGrid()
                plot2.draw();

                setTimeout(update2, updateInterval);
            }

            update2();
            console.log('done!');
        }
    });

})(jQuery, window, document);