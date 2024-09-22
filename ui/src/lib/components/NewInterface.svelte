<script>
  import { onMount } from 'svelte';
  import MessageInput from './MessageInput.svelte';
  import MessageContainer from './MessageContainer.svelte';
  import { messages, isSending } from '$lib/store';

  let containerHeight;

  onMount(() => {
    const updateContainerHeight = () => {
      const viewportHeight = window.innerHeight;
      containerHeight = viewportHeight - 200; // Adjust for header and footer
    };

    updateContainerHeight();
    window.addEventListener('resize', updateContainerHeight);

    return () => {
      window.removeEventListener('resize', updateContainerHeight);
    };
  });
</script>

<main class="flex flex-col h-screen bg-background text-foreground">
  <header class="bg-primary text-secondary p-4">
    <h1 class="text-2xl font-bold">Devika AI</h1>
  </header>

  <div class="flex-grow overflow-hidden" style="height: {containerHeight}px;">
    <MessageContainer />
  </div>

  <footer class="bg-secondary p-4">
    <MessageInput />
  </footer>
</main>

<style>
  :global(body) {
    margin: 0;
    padding: 0;
    font-family: Arial, sans-serif;
  }

  main {
    max-width: 1200px;
    margin: 0 auto;
  }

  @media (max-width: 768px) {
    header {
      padding: 2px;
    }

    footer {
      padding: 2px;
    }
  }
</style>
