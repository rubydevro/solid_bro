document.addEventListener('DOMContentLoaded', () => {
    console.log('Dashboard initialized');

    // Add interactivity to buttons
    const deleteButtons = document.querySelectorAll('.btn-danger');
    deleteButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            if(confirm('Are you sure you want to delete this user?')) {
                const row = e.target.closest('tr');
                row.style.opacity = '0.5';
                setTimeout(() => {
                    alert('User deleted (mock action)');
                    row.style.opacity = '1';
                }, 500);
            }
        });
    });

    const editButtons = document.querySelectorAll('.btn-icon:not(.btn-danger)');
    editButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            console.log('Edit clicked');
        });
    });
});
