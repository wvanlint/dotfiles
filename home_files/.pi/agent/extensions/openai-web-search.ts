import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function supportsSearch(model: { provider: string; api: string } | undefined) {
  return model && (
    (model.provider === "openai" && model.api === "openai-responses") ||
    (model.provider === "openai-codex" && model.api === "openai-codex-responses")
  );
}

export default function (pi: ExtensionAPI) {
  pi.on("before_provider_request", (event, ctx) => {
    if (!supportsSearch(ctx.model)) return;
    const payload = event.payload as { tools?: { type: string }[] };
    const tools = payload.tools ?? [];
    if (tools.some((tool) => tool.type === "web_search" || tool.type === "web_search_preview")) return;
    return { ...payload, tools: [...tools, { type: "web_search" }] };
  });

}
