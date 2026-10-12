import { useEffect, useRef } from 'react';

export default function App() {
  const iframeRef = useRef<HTMLIFrameElement>(null);

  useEffect(() => {
    const focusIframe = () => {
      try {
        iframeRef.current?.contentWindow?.focus();
      } catch {
        // ignore
      }
    };

    focusIframe();
    const timer = setTimeout(focusIframe, 300);
    window.addEventListener('focus', focusIframe);
    window.addEventListener('click', focusIframe);

    return () => {
      clearTimeout(timer);
      window.removeEventListener('focus', focusIframe);
      window.removeEventListener('click', focusIframe);
    };
  }, []);

  return (
    <iframe
      ref={iframeRef}
      src="/mundo-navegador.html"
      title="Voo livre no Sistema Solar"
      className="fixed inset-0 w-full h-full border-0 m-0 p-0 overflow-hidden bg-black"
      allow="fullscreen; autoplay; pointer-lock"
    />
  );
}
