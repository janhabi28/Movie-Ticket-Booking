// bookingStatsChart.js

document.addEventListener('DOMContentLoaded', () => {
    const ctx = document.getElementById('bookingChart').getContext('2d');

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: chartLabels,
            datasets: chartDatasets
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'top' },
                title: {
                    display: true,
                    text: 'Monthly Bookings per Movie'
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: { display: true, text: '# of Bookings' }
                },
                x: {
                    title: { display: true, text: 'Month' }
                }
            }
        }
    });
});
